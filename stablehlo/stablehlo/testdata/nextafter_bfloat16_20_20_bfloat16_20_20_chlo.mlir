// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xbf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<20x20xbf16>, tensor<20x20xbf16>)
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = chlo.next_after %0#0, %0#1 : tensor<20x20xbf16>, tensor<20x20xbf16> -> tensor<20x20xbf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> ()
    return %2 : tensor<20x20xbf16>
  }
  func.func private @inputs() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}, tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x2AC0A64006C05BC0E3BF9BC0123DB4BF74BFF7BDC9400EC01340163E244010C0A3BF41BE2A406D40B73F08C056BF33407DC04BC0794091C0C7BDE93FA2BF6EBEB6C0AABFD5C0AD3F3DC01D40FD405440FDBF41409FBF05BF19C027400BC07FBFC03EB7C076C0A1C07FBF87BD5B3F2240C7C0304058C07D40DA40E8BF923FFF3F0B40E23F1240ACBE303F1C40A3BF58C0D1BF613F13404B4022C04F3F8A3FB140D03FE33EDD403AC05040B53F30BFE43FB2C00840693F7340823F0840DDBF9B3E8DBF63BDDEBE463F4E3F23BFE7BE323FBB3FD83F1EC0114033C028410DC00940D440B2BE00405A3F91408EC071BF6FBF214022BF5440643FF7BFF83F1D3FEF3DB1BF52C00EBE5F40C2BF95BFA8405C3F07C034BEB0407C3F13407DC0B23F2F3F1A4030BF77BF63BFC3BE78C031BE9040CB3F2BC07ABFA5402F3E9CC0E93F9D3FAE3F8D40B9C0893F2EC0DEBF624079BE15BF1ABF103F2240AB3E53BF3F40EDBFD13F903D38C0343FA1BF3AC097C0823F67C09EC0003F0F40164010402E4068C0E03F60C0B44022409B40E1C029C00440133FAD406D4048C0CABD7C407A401A409D4044C0C6BF37C13DC06D4095C0CBC018C0A2BE9BBFB73F44404F409EBEBD3F4C4026BF9C3FE5BFDEBFC34013C0DDBE18404D40BCBFAC3E873E803EF83F08BFEFBD02BFE33F9F3EED3F9A4089400D3FADC0D9BFA7BFAE3F373F813F7CC082C07CC0E83EE13E5DBF664083BE8EC082C0B240044054C01CBF5BBFD33F8ABF27BF4740F4BF23404140BB3F244018402F40F5BF4A40F3BE2FBEAA4065BF0740E43FE6BF6EBF0A3FE53E6B4048C01DBF45BFFEBE833F1FC085C06AC0854066C07EC034C07B3F5C400A40DCBF71C0C9C007BF0D401AC04D4084C0C1BF2CBFE7C09CBF8A402EC0CFBF24C023C020BEAFBF1E4074407140E13E86BF843E80BD473EB6BF2AC0A53FE1BF3B3FA13ED23DA9BF1040FFBE30405B4098BF453FC1BF39408F3F0640F73FAB3FE33F21C08FC0433F0AC098C0423FE63F3BC05F4086C0A03F62BF5D3DABBE593E4440B33F8FBFD7BF88BF20C0A33F043F94C082C08740F1BF1BC015C04CC0B340833F064080BDF13FA6C0BF40C7BF26C0BE3F8D3F93BFD63F9640"> : tensor<20x20xbf16>
    %cst_0 = stablehlo.constant dense<"0x333F98BFFE3F24C0CC3FA73F873E154083C0153F68401C3F40407C409EBF2A4054C0D7BE52BF1FC067C0573F28C03040BF40E03E38C08C3F36BFD53F6740053F77C08A405DBF523F1EBE2BBE22C0BBBEA540EB40294052407AC03EC03E3FA03E083F70408DC0C240FB3F76BF0240CB4090C081C0C9C02840B93F9FBE0EC0BA407CC038C00AC0E2BE4F4082BE8DBC0CC001407DC0C3C03C40B53EEB3F23BF9D3F8C3FAAC073BFF1BE8CC08C4019C0DD3F18C022409E40F0BFF7BFA3C0D33BFF3F97C0303F074049BCE7BF65C032C028C0D9C0A43FCAC0ACBEC73F09403E40E7BEDCBF14BCD6BF11BF8BBF87405AC0DBBFCEC0E8BFB03FC3BEAB3F09C00640133FC0C05CC0FCBF4B4025C021C00EC07F4087BEAAC01BC032C0853F1BC0AEBEFB3FD3C0F23FE7BE9F3F0AC0993F0CC03DBFF1BF663E8B3FE4BFA2C03D3FA9BF51C08440B93F633FEC3FE4C08F3DB53FDFBFCE3E383E84BF49BF9BBFBBBDBE40E2C0DDBF82C038C09BBFEAC09CBE4DBE0CC00D405C40A83F67BFF8BE2DC027C0244133C0DE3F39C0E63F9F404BC084BED7BFE6BF243E13BF35BD4DC0DD40804087C0833F28C03A40D4BED6BF12C1F7BE053EAF40AE3ECEBEEEBF54C08940F63FAF3ECEC0B43E603F613F5B40983ED0BE88BC89BE8940973EB0C077C0383FB23FBEBF3A406F3F61BF783F4EC09F4087BF93BFD7C02DC0ADBE2FBEB03F1640FCBF8EC0AD3E3E404FBFF33FB7C05A40344001C0A53F35C027C09BBF1BC0D5C03DBF6FC086C07C3FAE3F0740BABF133F26C0513F3A408840F740883F19C03BBF02400EC093BF7E40BFBFFCC06BC0903F9440D7C0874087406640F1BC9240D0BF82BDBABF094009C0B4BF6C40E8BE82BF8440394042C0A7C0AB403F403540FDBE59BF4A40B2C00B40C2C057C02C3EF4C01F3F7BBFAE3F29BFA4BF303E38C08E4010BF2ABF7E40B8C09ABE14409C40134010C09BBF44BE1840F8BF37C0AEBF3A40884069BF22401D40923F923F0BC1F03EC440673F1ABD94C0A340813F3CC067C01DBF733F56C0A5C09B3F9540544001C079400EBE3CBE0EC0683F1540D9C05EC00FC078BF92BF78405F3FC23E6CC0F9C0573F13C07CC0634003400C4016402BBF19BF1E40"> : tensor<20x20xbf16>
    return %cst, %cst_0 : tensor<20x20xbf16>, tensor<20x20xbf16>
  }
  func.func private @expected() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x29C0A54005C05AC0E2BF9AC0133DB3BF75BFF6BDC8400DC01440173E23400FC0A4BF42BE29406C40B63F07C057BF32407CC04AC0784090C0C8BDE83FA1BF6DBEB5C0A9BFD4C0AC3F3CC01C40FC405340FCBF42409EBF04BF1AC026400AC07EBFC13EB6C077C0A0C07EBF88BD5C3F2340C6C02F4059C07C40D940E7BF913F00400A40E13F1140ADBE313F1B40A2BF57C0D0BF603F12404A4021C0503F893FB040CF3FE23EDC4039C04F40B63F31BFE33FB1C009406A3F7240813F0740DCBF9C3E8EBF62BDDDBE453F4D3F24BFE8BE313FBA3FD73F1FC0104032C027410CC00840D340B1BEFF3F593F90408DC072BF70BF204023BF5340633FF6BFF73F1E3FF03DB2BF53C00FBE5E40C3BF96BFA7405D3F06C035BEAF407B3F12407CC0B13F303F19402FBF76BF62BFC4BE77C032BE8F40CA3F2AC079BFA4402E3E9BC0E83F9C3FAF3F8C40B8C08A3F2FC0DDBF61407ABE14BF19BF0F3F2140AA3E52BF4040EEBFD03F8F3D38C0333FA2BF39C096C0813F66C09DC0013F0E4015400F402D4067C0DF3F5FC0B34021409C40E0C028C00340123FAC406C4047C0CBBD7D407B4019409C4043C0C5BF36C13CC06C4094C0CAC017C0A1BE9ABFB63F434050409DBEBC3F4B4025BF9B3FE4BFDDBFC24012C0DCBE17404E40BBBFAB3E863E813EF73F09BFEEBD01BFE23FA03EEC3F9B4088400C3FAEC0DABFA6BFAD3F383F823F7BC083C07BC0E93EE03E5CBF654082BE8DC081C0B140034053C01DBF5CBFD23F89BF28BF4640F3BF22404040BA3F234017402E40F4BF4B40F2BE2EBEA94064BF0640E33FE5BF6DBF093FE43E6A4047C01CBF46BFFDBE843F1EC084C069C0844065C07DC033C07A3F5B400B40DBBF70C0C8C006BF0C401BC04E4083C0C0BF2BBFE6C09BBF89402DC0D0BF25C022C021BEAEBF1D4073407040E03E85BF833E7FBD463EB5BF29C0A43FE0BF3C3FA23ED33DAABF0F40FEBE2F405A4099BF443FC0BF3A408E3F0740F83FAA3FE23F22C08EC0443F09C097C0413FE73F3AC05E4085C09F3F61BF5C3DACBE5A3E4540B43F90BFD6BF87BF1FC0A23F053F93C083C08640F2BF1AC014C04BC0B240823F054081BDF03FA5C0BE40C6BF25C0BF3F8E3F92BFD53F9540"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
}