import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/other/unpack_polyline.dart';
import 'package:geolocator/geolocator.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});
  

  final String polyline =
      'qtgxFylxuAEJ?LD\\RnA?PCREPILmAn@??]eAOi@c@}B[}A_@oBa@gC??mA@cD|@??IcCCq@KqCAII_CMgDCg@??[?}CCO?SAaDCGAq@@W?e@E??U_@]a@IEaCIG@E@C@s@bA?@A@A?A?S?U?K?IAMG??CEAAACEAE?E@CD??UFSDyA???QAE?gDCsAC{AA???mAT{B??{Ae@iA]ME??XkAHSDMHGREx@KB???FIBI?OASMwDOuDMwCCm@??REFCHGJMLYD[?WE[ISAAIMOKQGU?MDQJMNCJ??Yg@k@cAg@_AKSGKiAwBcB{AKIKEaAi@k@Gi@Jg@N??M@EAQGCOEOEOEIWa@g@q@KKIGICKCIAG?K@_@Je@PYHM@M?MCOGYe@Iq@F]N{@Xy@f@a@^OlB[DAFCNK??HAFAN?JF\\NNBF?L???LC\\GRGRININMHKb@o@DKFSH[FYBUBWJcCV{EBKBIFGFCVCNCJK??@?B?BA@ABC@G?GCGCC??IUAKAQDqADkAHqAXiCFc@Fc@\\mC@I@I?O??FFFDb@F@@B@fAd@rAj@|@^LFv@\\zAl@FBB@@@vAj@FBD@F?x@EF?f@CJCdAi@t@a@d@Wd@WxAw@HEBAHGLIPMDGHG?AFKFIN[FUBQBMB]@a@BUDMBKJMLMf@[l@WHGTK??UEC?A?C?A@E@{Al@KHGDA?C??AAAKq@AA?A@A@A@AjAg@nAg@XoDPW??a@aBI[Oq@??cAb@??I_@????I]Ka@YoAWcA??WRk@b@]VYm@??aC_DOASCE?O???K_CAm@?U?i@PuA??k@Gu@EKAQGKCQI??OIOGMCSEQCYA]C_@Cc@GQAOCc@CSAWAOA??QCe@Ee@Ak@@g@BM@??ASE{AOyEAQ??eDRqAH[Bi@BeAH??CDCHCH?JNdALv@NlADXJt@F@??iBn@c@T??@XaAlDIXENCHCLEp@MxAGbA?L?H?J@JBJDHDHFHDFHDjBx@JFLJFDJFNNDDDHFHDF?@BF@FBJ@R@H??U@ILCDq@rA[l@y@jBSrAQpAIj@mArFm@dBIVIb@AHEV?BCd@An@?r@DpA?h@A@EvAA^?vAm@p@Yl@a@~@??Lb@R@JJH@??HAJAVIb@Md@Mf@LDDHHHPDH@FBN\\rB?LADE@ADAF??ADABKJINOJGBE@mBZ_@Ng@@Yx@Oz@G\\Hp@Xd@NFLBL?LAXId@Q^KJAF?H@JBHBHFJJf@p@V@DHDNDNBN?J?TAR?BCrAChBAtC?@Bd@Fv@B\\Fn@@JBPB@@P??HPDFFDL@d@CPA??LFDDBBVXrAfBbAtA~@nADD??lClDLP??YNeB~@IB{@d@{@`@??CMm@gCW_A??';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                padding: const EdgeInsets.all(20.0),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(41.3518, 14.3689),
                    initialZoom: 9.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.greenway',
                    ),
                    PolylineLayer(polylines: [
                      Polyline(
                          points: decodePolyline(polyline).unpackPolyline(),
                          color: Colors.blue,
                          strokeWidth: 3.0
                          )
                    ]),
                    CurrentLocationLayer(),
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright')),
                        ),
                      ],
                    ),
                   
                  ],
                ))));
  }
}
