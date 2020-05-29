import 'package:flutter/material.dart';
import 'package:geolocation/widgets/image_item.dart';
import '../providers/image_provider.dart';
import 'package:provider/provider.dart';
class ImageScreen extends StatefulWidget {
  static const routeName = '/image_screen';
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  var _isinit=true;
  var _isLoading=false;
  void didChangeDependencies() {
    if(_isinit){
    setState(() {
        _isLoading=true;
      });
      Provider.of<ImageProviders>(context,listen: false).fetchImages().then((_){
        setState(() {
          _isLoading=false;
        });
      });
    }
    _isinit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    List<ImageM> loadedImages=Provider.of<ImageProviders>(context).images;
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body:_isLoading?Center(child: CircularProgressIndicator(),) :GridView.builder(
        padding: const EdgeInsets.all(12.5),
        itemCount: loadedImages.length,
        itemBuilder: (ctx, i) => ImageItem(
          loadedImages[i].id,
          loadedImages[i].imageUrl,
          loadedImages[i].date,
          loadedImages[i].uid
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
