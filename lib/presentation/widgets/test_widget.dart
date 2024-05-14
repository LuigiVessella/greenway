import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenway/services/other/unpack_polyline.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body:  Center(
        child: Column(
          children: [
            const Text('ciao'),
            FilledButton(onPressed:  () => unpackPolyline(), child: const Text('premi'))
          ],
        ),
      ),

    );
  }

  void unpackPolyline(){
    String geometry = "uhpxF}mavArAuAj@~@Xj@DGr@eA\\e@FCLUVm@To@\\aAFIFAFDx@rBJTBN?D?B@DBB@@B@B?BABABC?C@C?EBEBCzA}ARUJQHQHWFYDWBY?Y?[IsACc@Ci@AiAG_A@gAFgALmAN_AXcAJYHULWPYJOTYVYt@u@vAyAlAsAf@m@n@aAfEmEvByBpCuCpDqDpAsA\\_@VWp@s@z@}@VWpBqBPCLAL@NFJHJNz@rAzA~BVb@Vf@^v@bAlCZz@LZP\\hBbCDH~A`D^r@Tb@Xr@Tl@N`@Tj@Pj@Rt@Pl@Nn@Jl@Pt@Jn@Jp@Hl@Jv@JfAFj@FhALdCZzGZvGVbFJbC?hBCdBCfAI|AOnBqAxKIf@MnAG`ACj@CfAAx@@`@DhAFx@H~@P`BPnBBj@@r@AZCXOjAYjASr@]nBKlAE~C@xAJ`CTzB`@bCd@pBdAlCz@pCd@fC`@jEd@~Cr@|Bz@lBnBxCNZR`@`A~A|DpGf@|@Tf@`@~@X`A`C|HZlAFRj@fB~@|CnBtGX`AV~@fAnExA`G\\lAb@xApArDnAxEdQhn@fDjGbAdBtAjBZXXThAbAnC|B~AtAf@f@b@l@dEjG`B~BlBzC\\h@XZTV\\XXR\\TD@XN\\NVJVF`@FVB^@X?XATCLAPCHCNEZIb@OdBm@~CiAx@Y|CcAlA_@\\GTETCTCTAR?R?X@^@VBXDZFTHLD@?n@XPJVNVPFDd@\\jBvAjCnBd@ZXP\\RXJ^NTHXF\\FZD^B|CJZBVDTFVFXLXPTPTTNNPTNTFJHRJRz@dC~@jCvAxD|AdEPh@J^Nj@Lr@Hr@Dv@Bt@?t@Cx@Ev@MxAMlAQnBMnBGjBCxB?tBDhBDjAHvALdBb@rD`@|B|@tExBnMrA|GDT@R@LANANCN]~A_@fBGXCZAR?T@J@JFd@Fb@F\\Pf@Tp@b@j@DNBNDNDJFJd@d@JFPHPDX@VAxF]|AE`Ea@PATApAHH?XAjAPd@NZDb@@l@Br@CzHe@j@G\\G`Ba@zBk@x@Q~@WbIkBlBg@r@a@BCXQjBiAVMACa@_BGYa@_BIWCMGYKe@S{@i@cCu@oDs@qDK]g@wCy@aEImBASKsCQyDAe@C_@Cu@Q_BQiAGYUmAIa@WoAI[AE[uA_@}AI]K_@m@oCcA{IiKobAI{@AK?I?I?E@C?E@EKUBE@C@E?E@G?E?E?GAGCGACCECCEACAEAC?C?C@E@E@E@CBC@ABC@CBA@AD_@XYROLGFC@A@C@C?E@G?G@I?O@}@@UCKAIAeAUIAIA??A?A?A@A?A@C@?BCBADADAJKFCBA?E@c@?I?u@@q@@g@?q@@S?e@AKAKCMCICECAAGIEMEMEQCQEQAGQaACMIo@EQESAKCICIEIGKWi@OYEEECCACAEACAC?C?C@A?C@CBqAvAC@EDGBG@E@G?}CNqABKAmABGECCCCCECECEAGCECGAGCEAGAE?E?G?E?G?K@_@Bo@@c@?M?M?M?K?K?GAI?EAGAEAECEACAECCCCCACCEAEASCWAYACAGAEAECEEECCECECECGAGAIAI?K?I@I?IBKBKDGFKZ[JKLKFIFG@EBEBEBG@EBI@IBI@I@K@K@M?M@OF_BB}@FcBLqCHwB?K?I?IAMAOAKCOQ{@Ku@]gCG_@Mi@EMEKEKGIgAwAGGEICGAKAK?K?M@MDYZaB@K@M?K@OAKAMCMCMEOIQMSMUMMMKQKOGOE_@Ea@EUGMEOIIGSYEGCECGCGAGAGAIAOAUAUGcBAWAKUkGA[Ce@Ec@Io@O_AKc@CKEGGMIKKIKGQIYGe@QIEIGIKKMGMEMAKAM@K?I@GBIDIr@qAFMDOBM@O?mA@cH?iGAQ?W?[?M?K?GAE?G?EAEAEAGCGAEACEKGSKWMSISOSMSOMQSGGGEGGMIMGMGKEMEMAqCUg@ESCAAWG[KQEmCkACAqCaAEACAA?C?A?C?A@A@A@EHQ`@?@w@jBEHA@CDEBC@EAyA[E?G@ID{@^UJIFm@Vg@ZMLKLCJELCTA`@C\\CLCPGTOZGHGJ?@IFEFQLMHIFC@IDyAv@e@Ve@Vu@`@eAh@KBg@BG?y@DG?EAGCwAk@AACAGC{Am@w@]MG}@_@sAk@gAe@CAAAIK[]CCa@m@MQ?AAEc@qAIOGMe@g@i@k@GIKOIQQg@EUG_@O{@OeAEWE[AIASCKAGCG?AEGGIEIEEOOKGGEMKKGkBy@IEEGGIEIEICKAK?K?I?MFcALyADq@BMBIDOHY`AmDAYb@UhBo@FCRC~@K`@Gz@IGmBOkFqAH[Bi@BeAHIEECGEEIQ_@Q_@AAgAuBO[gBeE_@aA[s@M_@Sq@o@aCK]W{@K]AEi@mBc@_BM[a@aAq@{AU_@cBgC_BeCEEQYe@o@IM_AqAo@_Am@y@QWW]S[IKg@s@e@q@SY]e@MOOUqCaEe@s@k@w@m@{@cAuAq@}@QU_@a@IKaBoBCC?AAC?C?E@EB[@IDKBG@CBK?KCKGKk@k@i@k@OQGAG@A@EBGHILITGHC@A@A?CA{@cAc@e@}AeBQUOQoAuAk@a@cAgAIMGIGM?CACACA?CAY@a@Ho@LgAV{F~AeCt@EBC@QBM?s@FQBM@c@A{@EUGcBi@MM{B{@OIu@a@gAw@sAkAy@s@yA_AaCmAKE[M[Gm@AwE`Ak@JyAJ}@?iDYaHq@gD_@SAsAKkAK]EaAI_BM}@IWCMEMEAAIGMMIKEKEKCKIUKWKICCAGEKEGIEIAI?IDGFEJCL?JETEJEHIJUTWXi@h@U`@WV_HhHsCtCzAhCR\\n@bA^t@sAtA";
    List<List<num>> points = decodePolyline(geometry);
    print("punti: $points");

    num distanceInMteters = Geolocator.distanceBetween(points[0][0].toDouble(), points[0][1].toDouble(), points[1][0].toDouble(), points[1][1].toDouble());

    print('distanza in metri: $distanceInMteters');

  }
}