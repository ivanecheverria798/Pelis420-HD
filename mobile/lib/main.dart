import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const Pelis420HDApp());

const sampleVideo = 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

class TitleItem {
  const TitleItem(this.id, this.name, this.year, this.type, this.genre, this.synopsis, this.color, {this.url});
  final String id, name, type, genre, synopsis;
  final int year;
  final Color color;
  final String? url;
}

const catalog = <TitleItem>[
  TitleItem('bbb','Big Buck Bunny',2008,'Película','Animación · Comedia','Cortometraje de prueba de Blender Foundation. Vídeo de demostración bajo licencia Creative Commons Attribution 3.0.',Color(0xFF397C69),url:sampleVideo),
  TitleItem('neon','Horizonte de Neón',2025,'Serie','Ciencia ficción','Una tripulación descubre señales misteriosas en los límites de una colonia espacial. Ficha ficticia.',Color(0xFF59478F)),
  TitleItem('samurai','El último samurái',2024,'Anime','Acción · Aventura','Un aprendiz emprende un viaje para recuperar una reliquia perdida. Ficha ficticia.',Color(0xFF9B4D45)),
  TitleItem('ocean','Bajo el océano',2023,'Documental','Naturaleza','Un recorrido por ecosistemas marinos. Ficha ficticia.',Color(0xFF286B91)),
  TitleItem('pixel','Mundo Pixel',2025,'Anime','Fantasía','Una aventura en un mundo construido a partir de recuerdos. Ficha ficticia.',Color(0xFF98713A)),
  TitleItem('night','La ciudad dormida',2022,'Película','Misterio · Thriller','Una periodista investiga sucesos extraños en una ciudad costera. Ficha ficticia.',Color(0xFF48536D)),
  TitleItem('orbit','Órbita Cero',2024,'Serie','Drama · Ciencia ficción','La primera misión tripulada a Marte afronta una decisión inesperada. Ficha ficticia.',Color(0xFF8A485F)),
  TitleItem('forest','El bosque de cristal',2021,'Anime','Aventura · Fantasía','Dos amigos buscan el origen de un bosque luminoso. Ficha ficticia.',Color(0xFF47764D)),
];

class Pelis420HDApp extends StatelessWidget {
  const Pelis420HDApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title:'Pelis420 HD', debugShowCheckedModeBanner:false,
    theme:ThemeData(brightness:Brightness.dark,scaffoldBackgroundColor:const Color(0xFF101014),
      colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFFE50914),brightness:Brightness.dark),useMaterial3:true),
    home:const MainScreen(),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState()=>_MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tab=0;
  String query='';
  Set<String> favorites={};
  Map<String,int> progress={};
  bool loaded=false;

  @override
  void initState(){super.initState();_load();}
  Future<void> _load() async {
    final p=await SharedPreferences.getInstance();
    if(!mounted)return;
    setState((){
      favorites=(p.getStringList('favorites')??[]).toSet();
      progress={for(final s in p.getStringList('progress')??[]) if(s.contains(':'))
        s.substring(0,s.lastIndexOf(':')):int.tryParse(s.substring(s.lastIndexOf(':')+1))??0};
      loaded=true;
    });
  }
  Future<void> _favorite(TitleItem item) async {
    setState(()=>favorites.contains(item.id)?favorites.remove(item.id):favorites.add(item.id));
    final p=await SharedPreferences.getInstance(); await p.setStringList('favorites',favorites.toList());
  }
  Future<void> _save(String id,int seconds) async {
    if(seconds<1)return;
    setState(()=>progress[id]=seconds);
    final p=await SharedPreferences.getInstance();
    await p.setStringList('progress',progress.entries.map((e)=>'${e.key}:${e.value}').toList());
  }
  void _details(TitleItem item)=>Navigator.push(context,MaterialPageRoute(builder:(_)=>DetailPage(
    item:item,favorite:favorites.contains(item.id),seconds:progress[item.id]??0,
    onFavorite:()=>_favorite(item),onProgress:(s)=>_save(item.id,s))));
  List<TitleItem> get filtered=>catalog.where((e){
    final q=query.toLowerCase().trim();
    final match=q.isEmpty||e.name.toLowerCase().contains(q)||e.genre.toLowerCase().contains(q)||e.type.toLowerCase().contains(q);
    return match&&(tab!=2||favorites.contains(e.id))&&(tab!=3||(progress[e.id]??0)>0);
  }).toList();

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Pelis420 HD',style:TextStyle(fontWeight:FontWeight.w900)),
      actions:[IconButton(onPressed:()=>setState(()=>tab=1),icon:const Icon(Icons.search))]),
    body:!loaded?const Center(child:CircularProgressIndicator()):
      tab==0?_home():_listing(),
    bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(() { tab=v; query=''; }),
      destinations:const [
        NavigationDestination(icon:Icon(Icons.home_outlined),label:'Inicio'),
        NavigationDestination(icon:Icon(Icons.search),label:'Buscar'),
        NavigationDestination(icon:Icon(Icons.favorite_border),label:'Favoritos'),
        NavigationDestination(icon:Icon(Icons.play_circle_outline),label:'Viendo'),
      ]),
  );

  Widget _home()=>ListView(padding:const EdgeInsets.only(bottom:24),children:[
    Container(height:245,margin:const EdgeInsets.all(16),padding:const EdgeInsets.all(22),
      decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(
        colors:[Color(0xFF702B3B),Color(0xFF22212D),Color(0xFF15151B)],begin:Alignment.topLeft,end:Alignment.bottomRight)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.end,children:[
        const Text('TU ESPACIO DE ENTRETENIMIENTO',style:TextStyle(letterSpacing:1.3,fontSize:10)),
        const SizedBox(height:8),const Text('Pelis420 HD',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900)),
        const Text('Películas, series y anime en un solo lugar.'),const SizedBox(height:12),
        FilledButton.icon(onPressed:()=>_details(catalog.first),icon:const Icon(Icons.play_arrow),label:const Text('Probar reproductor')),
      ])),
    if(progress.isNotEmpty)_shelf('Continuar viendo',catalog.where((e)=>(progress[e.id]??0)>0).toList()),
    _shelf('Recomendados',catalog.take(5).toList()),
    _shelf('Películas',catalog.where((e)=>e.type=='Película').toList()),
    _shelf('Series',catalog.where((e)=>e.type=='Serie').toList()),
    _shelf('Anime',catalog.where((e)=>e.type=='Anime').toList()),
    const Padding(padding:EdgeInsets.all(18),child:Text('Catálogo de demostración. Las fichas ficticias no incluyen vídeo.',style:TextStyle(color:Colors.white54,fontSize:12))),
  ]);

  Widget _shelf(String title,List<TitleItem> items)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Padding(padding:const EdgeInsets.fromLTRB(18,8,18,10),child:Text(title,style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold))),
    SizedBox(height:180,child:ListView.separated(padding:const EdgeInsets.symmetric(horizontal:16),scrollDirection:Axis.horizontal,
      itemCount:items.length,separatorBuilder:(_,__)=>const SizedBox(width:12),
      itemBuilder:(_,i)=>SizedBox(width:145,child:Poster(item:items[i],onTap:()=>_details(items[i]))))),
    const SizedBox(height:12),
  ]);

  Widget _listing()=>Column(children:[
    if(tab==1)Padding(padding:const EdgeInsets.all(16),child:TextField(onChanged:(v)=>setState(()=>query=v),
      decoration:InputDecoration(hintText:'Buscar títulos, géneros o categorías',prefixIcon:const Icon(Icons.search),filled:true,
        border:OutlineInputBorder(borderRadius:BorderRadius.circular(15),borderSide:BorderSide.none))))
    else Padding(padding:const EdgeInsets.all(18),child:Align(alignment:Alignment.centerLeft,
      child:Text(tab==2?'Mis favoritos':'Continuar viendo',style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold)))),
    Expanded(child:filtered.isEmpty?Center(child:Text(tab==2?'Aún no tienes favoritos.':tab==3?'No hay reproducciones guardadas.':'No encontramos resultados.')):
      GridView.builder(padding:const EdgeInsets.all(14),itemCount:filtered.length,
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,childAspectRatio:.78,crossAxisSpacing:12,mainAxisSpacing:14),
        itemBuilder:(_,i)=>Poster(item:filtered[i],onTap:()=>_details(filtered[i])))),
  ]);
}

class Poster extends StatelessWidget {
  const Poster({super.key,required this.item,required this.onTap});
  final TitleItem item; final VoidCallback onTap;
  @override
  Widget build(BuildContext context)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Expanded(child:Container(width:double.infinity,decoration:BoxDecoration(borderRadius:BorderRadius.circular(14),
      gradient:LinearGradient(colors:[item.color,item.color.withValues(alpha:.35)],begin:Alignment.topLeft,end:Alignment.bottomRight)),
      child:Stack(children:[
        const Center(child:Icon(Icons.movie_creation_outlined,size:48,color:Colors.white70)),
        Positioned(left:8,top:8,child:Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),
          decoration:BoxDecoration(color:Colors.black54,borderRadius:BorderRadius.circular(20)),child:Text(item.type,style:const TextStyle(fontSize:10)))),
        if(item.url!=null)const Positioned(right:8,bottom:8,child:Icon(Icons.play_circle_fill,size:28)),
      ]))),
    const SizedBox(height:7),Text(item.name,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.bold)),
    Text('${item.year} · ${item.genre}',maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,color:Colors.white60)),
  ]));
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key,required this.item,required this.favorite,required this.seconds,required this.onFavorite,required this.onProgress});
  final TitleItem item; final bool favorite; final int seconds;
  final VoidCallback onFavorite; final ValueChanged<int> onProgress;
  @override
  Widget build(BuildContext context)=>Scaffold(body:CustomScrollView(slivers:[
    SliverAppBar(expandedHeight:280,pinned:true,actions:[IconButton(onPressed:onFavorite,
      icon:Icon(favorite?Icons.favorite:Icons.favorite_border,color:favorite?Colors.redAccent:null))],
      flexibleSpace:FlexibleSpaceBar(title:Text(item.name,maxLines:1,overflow:TextOverflow.ellipsis),
        background:Container(decoration:BoxDecoration(gradient:LinearGradient(colors:[item.color,const Color(0xFF17171D)])),
          child:const Center(child:Icon(Icons.local_movies_outlined,size:90,color:Colors.white54))))),
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('${item.year} · ${item.type}',style:const TextStyle(color:Colors.white60)),
      const SizedBox(height:10),Text(item.genre,style:const TextStyle(color:Colors.redAccent,fontWeight:FontWeight.bold)),
      const SizedBox(height:18),Text(item.synopsis,style:const TextStyle(fontSize:16,height:1.5)),
      if(seconds>0) ...[const SizedBox(height:20),const Text('Tu progreso',style:TextStyle(fontWeight:FontWeight.bold)),
        const SizedBox(height:8),LinearProgressIndicator(value:(seconds/540).clamp(0.0,1.0)),
        Text('Última posición: ${_time(seconds)}',style:const TextStyle(color:Colors.white60))],
      const SizedBox(height:22),SizedBox(width:double.infinity,child:FilledButton.icon(
        onPressed:item.url==null?null:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>VideoPage(item:item,onProgress:onProgress))),
        icon:const Icon(Icons.play_arrow),label:Text(item.url==null?'Vídeo no disponible en la demo':'Reproducir muestra'))),
      const SizedBox(height:14),const Text('Contenido de demostración. Solo Big Buck Bunny incluye una fuente de vídeo de prueba.',
        style:TextStyle(color:Colors.white54,fontSize:12)),
    ]))),
  ]));
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key,required this.item,required this.onProgress});
  final TitleItem item; final ValueChanged<int> onProgress;
  @override
  State<VideoPage> createState()=>_VideoPageState();
}
class _VideoPageState extends State<VideoPage> {
  late final VideoPlayerController controller; bool ready=false; String? error; int lastSaved=-1;
  @override
  void initState(){super.initState();controller=VideoPlayerController.networkUrl(Uri.parse(widget.item.url!));
    controller.addListener(_tick);controller.initialize().then((_){if(!mounted)return;setState(()=>ready=true);controller.play();})
      .catchError((Object e){if(mounted)setState(()=>error='No se pudo cargar el vídeo. Comprueba la conexión.');});}
  void _tick(){if(controller.value.isInitialized){final s=controller.value.position.inSeconds;if(s!=lastSaved){lastSaved=s;widget.onProgress(s);}}}
  @override
  void dispose(){controller.removeListener(_tick);controller.dispose();super.dispose();}
  @override
  Widget build(BuildContext context)=>Scaffold(backgroundColor:Colors.black,appBar:AppBar(title:Text(widget.item.name),backgroundColor:Colors.black),
    body:Center(child:error!=null?Padding(padding:const EdgeInsets.all(24),child:Text(error!,textAlign:TextAlign.center)):
      !ready?const CircularProgressIndicator():Column(mainAxisAlignment:MainAxisAlignment.center,children:[
        AspectRatio(aspectRatio:controller.value.aspectRatio,child:VideoPlayer(controller)),
        Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:16),child:Row(children:[
          Text(_time(controller.value.position.inSeconds)),
          Expanded(child:VideoProgressIndicator(controller,allowScrubbing:true,padding:const EdgeInsets.all(10),
            colors:const VideoProgressColors(playedColor:Colors.redAccent,bufferedColor:Colors.white38,backgroundColor:Colors.white24))),
          Text(_time(controller.value.duration.inSeconds)),
        ])),
        IconButton.filled(iconSize:40,onPressed:()=>setState(()=>controller.value.isPlaying?controller.pause():controller.play()),
          icon:Icon(controller.value.isPlaying?Icons.pause:Icons.play_arrow)),
        const Text('Vídeo de muestra · Big Buck Bunny',style:TextStyle(color:Colors.white54,fontSize:12)),
      ])));
}
String _time(int seconds){final d=Duration(seconds:seconds);final mm=d.inMinutes.remainder(60).toString().padLeft(2,'0');final ss=d.inSeconds.remainder(60).toString().padLeft(2,'0');
  return d.inHours>0?'${d.inHours.toString().padLeft(2,'0')}:$mm:$ss':'$mm:$ss';}
