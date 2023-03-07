// RUN: diff <(stablehlo-opt %s.0_9_0.bc --vhlo-to-version=target=current --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xf32>, tensor<20x20xf32>)
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = stablehlo.multiply %0#0, %0#1 : tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xf32>, tensor<20x20xf32>) {
    %0 = stablehlo.constant dense<"0xEFDC1AC07C5B8DC018AF39BF74330C401344703EBDD17BBF6B9C1ABF4A7B2EC0D813A43FEA517B3FF9A2AAC00CB7393F01F4833FF1D46E406BA0C840657E7740244C9DC0BA8B99BD110F9EBF9261E2BF6B2AC03FF99643406B329FBF99B5AFBEDDD19EBF603929BFEF70C93F2537983F4CFCBD3E2CB871BF8C6E8C3FF5630D40C7BA29C05FF21DBF571EAB3FED78B9BF8F211FC0754308402F6DD1BF0FF740C04752A04065552A3E4580D93F3E34083F008485C0E82B5E409C508FC07A08923F476BBFBE7D026740EF9E7D401D682CC033E4B7BFB186AE3E98BFEC3EC9475840B5890940CEFB16C059AF9940E07F76C03E3AF03FD8CC5A4091A989C0E0F495C02A2958400D6829C04FE45740AD9A48C01DF8AE40D919F83FAFDDAFBE5FF4D2BE34124E40BC13F03D5AC83D4034FBDABE23D812C00785C5BF5F63E5BFC1041C40B18D0E404C77AA4082E96EC0EC550740BFDAC23FF78FD23EBCA33340FB935DC0CBE2F83E59787A3F1B2E81404AA6A23E6E15494050E3E83F31DF3AC03889C13FC93C4ABD24DFD040A4E7CE3EF6A703405B2F02C0D3181040B87B8CBF41EA41BC70FB8040A8802640CDEEBDBF6F04F63EE14A853F2BEEF7BF64E31DC0873C913F07659A4075F75BBEAC455840144AADC098CAA1BEFE73F1BEEC687EBFB7104540C3CB41BC08580CC0CB6775C05AA6613F04DD15C0212FCA3F31ABC13EABAAD13E65C304409ECE274143E8DCBE3209E5BF277C55BF3194E53F5139B03E26F7A13F4200D93F14F14740BE62D2BE4466E5407298B040E7BDCAC0E71E16C0F339AA4047FC87BFFBCDE8BF6FDF0140E6DEC4BE8B0EE4BF4BFDF0C0233E4640485EA24034971B3FA9360E40EEAFDE3FA996823FD312DB3F1419A340FF7078C031DD9340772E054097C35540255E8B4088779FC096C160409F308AC04B1349C0C5F38940C4522C40426781C08ECE44C00A525F40305588BEBEE70BBD7E75FE3EDC078C3ED1CABF401ED035BFAAB213BF5CDD55C02AEB87C0D1872F406BAFC53FE9692DBE0D3519C0C54CE04073B6DEBF02F25940E6F207BF3F6BE7BFE50DCE3FE6E5B740FC1337C0377306BFA3F96940A4F89EBDCEF3FAC0A33345C096ABF2BFFB452A403A1B453FDA1C9AC02FEC23C067EFCD3FACDC0DC0EB1F23C0E45185404E2BC33F5833B73FECBEDFBE56903340B81736C0850A0E40F23305C051E13B3E89A914402BB9B6C07D53694038108240D6356E407DC11F3F54E3A6C0AE5E0EC083E8A5406E6119BF7F8520C0941C61BEFD0DE2BF81CFC4C059C35EBE4F492B40EA9225C01FB7223E2D8FA7BF9B2896404689EB3EA41A15C0406D0DC09AD505406655D3BEF186B63FDFFF83403301A2BF68C1E63E812D1B40D553C43FABD7BDC0986012C0C56D04C15ACAC6405797733E6A37EEBF58F32FC0F40AFF3FB92F05C06EA06840E1E1153FFEAF3D3F8E2D2BC0A31F87BFAF3132C0F3AE8ABF5197B6C030D4D5BF45261EBF0D2BE03E9EA3AF405CAE363F814F93C0953D293F864D6940630F5BC00F2D32401D6F6EBEE9CC4A40A959D7BF828EADBFE8F3C23FD4666CC0252F70400FAFFABF14B6FF3F9E07E3BF04446FBFFC5C2B407F6B02BEC71DF73D45F99F40EBA20BC0857FDE3F65028EC0C023E4BEC450AD4063FE6BC0EF8AF8C0D8719C3F691EADBFF8E5183FA9372FBFD6E32FC0EBDBDF3F6E1488C0D66A10C0B564BD3F2F2BD5BFFE2D02BF1C2DDD3FB7DE28C099F534C05E71613FA2C1B1BFC4AFB2BF0229A73F228177C0F8AF843EDF86053E8214D13F99E300BF072CAB3F184646C06755713FAEE2ACBEFBFC41406E082BC0C52A193F72D456BF68D783C0FB9DE7408731A6BFCE4F3FC03EA0893EC401693F72E3CC4027CDF83F03AF08403AD8EBBF3077ACBD6FE59FBFD5D1C2BE40B2F1BF582CB6BFFD27183FA8151EC01C5F174070D9D13FE1B67ABF4BAE51C0E00FA43F66793F4099E30240561FC63D8313C6BFCBBEBFBF95D0563FC9EC6B40ACA70040E7A6ABC0751532C053F273BFD22FA53FF7CE62C098B3A4BF0C82ACC07B53A83F0D562440332CBDC0C8A924C0725EFD3F5DAEF1BF9940D8BF61C3A34009E9AA3F69CB83BFBC8AD43F3ECC014151E7B33FC2F219BF78CE1C402AD65AC0ECBB5F403D248B407E610540150FE8BFA7BFB3BF8C195840C413854035543C403447E9BE187333C0587DA43F98F5293F79C86FC06C114AC0A9B32C4026D76D40C11AF53F81C8024058EE72C0EF88254072B3583F"> : tensor<20x20xf32>
    %1 = stablehlo.constant dense<"0x56DD81C0B0DCAA3E95310ABEEAC585C05A17A53F4604633F671986BFB7B466C0E9821EBF885C284011B1B640DE886D3FE102D6C063F36A40A6C8873F2B447C40002C0DBF084B5A40BE9F5D3FCC0DE0BFE1E668BFD529C23F809E5440A1FEAE3F61F162BF16986CC0AAE4EB3FA636CEC05FDF94C0A747253F071205C00D8859C00EACAC40B1F5403F49C556405AAC1B4028B010C04F1228400231ACBE886EC5BFF6050ABFC82EDC3F0104063F7D39C43E97670A402D8F8D3FD2AA07402555043F208D5B403993363F65BD0F40551CFBBFDADCB1C02668B3BE2F1B81BF7D2E95403EBA04C1E55E27401A5E14404108593FAE06953F107AD9409B6D934027CE8AC0D4F2864045EAF5BF2F6FE3C0EDD7B3BFBF65753EF12ABC3D0FE4B63E465993C086C3AABF18AF23BF7B7D93C0FB63A43F46003EC0848800C1A5BE67BF65CCA6BEAED848C0797EBCBF9497F8BF870CB03F8FA26E3FE627EF3F4297B84088C1773FC0A4E53E709909C07A5AEBBF2532B53FE768813EEB3B673D26476640F080953F3B6563BF97844F408DD49540EC0EA240FCCBBC3F79472A40932A22BFE122A6BF0C08E6BEEBD496BF4390F13E1CBEA7404BC1DEBFFE6AB83FFCA5543F7660614042D754BFFD9E97BFFF99A6BFA57872400ACBAF3F87C2D23F7B9CC03FB085763E35FA6C3FCF52B9BF54B53CC0572C22BE05C09C4093E40740CCDD0EC0E653FD3F1F4A59C0C80193C0FB603E3FAE3010BF5D1080BEC5F58D40C599A63EEE7740C09D92D34030E4A640F366C73F25581ABF93461D3FBF5ACC3F0B2A68C03E39C5BF3922D03EA7D139C07DC47E40135FD740918BCA3F53B78F3F81DBB9BF70608DC00E524B40D85D2DC0022149C0D47FCEBFA50E26402782B93FFDA8313F693D30404CEE87C0BB980140607F7AC0E71D26409732C33F9A42D5BF1A8A8440003B9F40E3E884C0A3348AC0118D8AC0B37DB9406070A6BFA549EA3F6CB0D23F5F247DC07179C03F21BFE9BEFA91413F482FA04053F6C740D15C7D3FABC77C3E19659F40DF3F43C0AFFAB93FBF35B9BEDFF99A40C1BCDC3F164E04C15964DE3F29703DBFC727FF3E6DE7B540DA7BC0BF6E901D40E9B919403627333F54526F3F40AA9A40C6A9083EE1BA4C3F9923C83F05DDB4407F09124050CE6A3E6D695AC02DCEAE40A8B5953F6D62C93F5C7B88BFF214C33FAB62674047C47B40603377C0886ADF3F0180943F37F07F4098282AC0FC2B77BF53C3E0C0A4BB003E035149BF466A13C0A1D40BC0EB56EDBD9D0D9FC0CB504540F0E881C0345238BF7057EFBF325B443FB6675EC08F92D83F8CD57BBE7AC5E9BFD2EE5BC013CB9540570E38BDBE8436C0D1981CBF05488FC0C5D1F53FD50401C0CFB33D3FF056913FB66A083FB55DBCBFC0AB903F83D7F9BC91135FC01DF1B33F643EEA3F2649F03F20831C405C3E61C03B59D63F2B0C25C090B3333F5B5F8340E0E62CBFC957F13E95545840FA72B3C0C71F2BC0444682BED8E06BC0E5C062BF6934F33F01670D40D213653EDA709CBD6ACC933EDEB501401F7AA33F00162B40607B3240267066BF6BD913C0E0429840520B3740D06B423FC46EDDBE9F502DBD40698840C36A3340BF8D30BEB5E1CBBFCA4A843F5E6487404CFD1F400283BE3FA6AFF63F654E3E40032729C0A9B146C038FD92BFA940AAC04AB2E43F4208AD3E6DE50FC05976B0BFDAC6C5BF976645BF34EAE2BF1BBEEF40F67ECBBC5D7399C0769DE3BEA7FE1BC09D16C4BF655F9BC02777F5407062DF40502A6B40800B18BFBF6995402C5504C0CFC5763E68337FC0539E1041EC6AA2BF80436DBF2EAC5A40DF88DCBD628605404C9D9B3F36EB813F0D445FC063654940694453C02612EEC0DA66C8C07C03C43E4C8111C002276A3FA381E43F1E08A33E3EC7133EA448473EE37CD3BE83F1B23FC68250BF1945AABE01005BC07A54303FCA56BD4094F88340538504403A7015C02C8DC63EEBDD933D0F7C7C40684E933FEDA265C02AC3E53F6A52823FA35EA3403F540D4051C4893E8B4AFC3F7047603FC1054ABDF2666540C96A29400B74234022435E4018CB853F1BA21E40B0AA3640D8DD41C09EC665C0BF113DC0233D56404380E9BFDED4DA3F3896B8C0222E9B3FD32EE23EAB848540D3F39EBEA6DA82C0E96CA5C0B38F07C1AC792E3F88249E40FFD9A3C03A4F09C0775913C007D2A040ED995C3DE498E4BFD93B2840191BF740DA73783F45365540BD89784059BCD5BF5049E1BFC4D3A03E"> : tensor<20x20xf32>
    return %0, %1 : tensor<20x20xf32>, tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x721E1D4138B1BCBFB378C83D3E8612C1CBF19A3E2F4F5FBF6FFA213FF03D1D414D304BBF99482540C68BF3C1C0512C3FE99EDCC0B5315B41B0D3D44053E27341F27B2D40FDED82BEA2D588BF93214640C0D3AEBF5F589440513884C06538F0BE05CB8C3F6D651C409A9E3940BC39F5C042F7DCBF5C0F1CBFA5FE11C0BE49F0C021F764C1BB1AEEBE3C8F8F402C9261C0C1E0B34007ECB24073DD0C3F6FD194402CE02CC08380923E16B9633F2BCD503E5E5E10C1E1B4754047E617C1E2F9163F4C2AA4BF9FC024406A670E41291DA940D886FF405D9EF4BD5FCBEEBE1D127C41219E8EC1766CC5C0BB23324157FA50C02BD80B40F6DFB9419E8E9EC1859DA2412CE563419BBBA24036CDBFC15BED8C40FEB8A73F995C363E8C48FBBDC6D7F23F7A7589C0C58099BD23AE5AC1739E0CBF24F9D940B05746417EA7CF3F4D4F4BBFB5AEDFC0A607FBC0ACFFE74063233A4019A3B53F39B5443FD3878141497156C00C435F3E87A006C0F585EDC0DD3EE63E654C4B3F9F5BD23D761828C1AF0CE23FDFA3333D9C50A9413831F23FECAF2641050540C06EB1BF404FFB313FA3B07B3CE9CBE7BFBC3344C0D73833BF9733214027F7E7BFCE9A32C0AE2603C0D9B97F407C5D80C09247823E47BF8CC0B121A4C1A033DEBEA0C846BF336ABFBFF9C43D3F416533BC07324B400CE634415AF20EBE2E8637C1C1A65640812958BF627A4F3F2260E1C09FB940C21148A4BEBA00813F7297553E0D9EFE40095EE53D7A8A73C07E5733418B5882415DDF23BF814E8AC05AFC584032D721C1A9240841A82403C14F1EDDBE82FBA8405F3F014150A025C0CF6F34C0104A07C1E2EC8FC03056B3C18A25F73F249EC0C0D8F4AEC0E2ACD2BFBD1A8E401660EC40206A2CC014974B41F36E0DC12F6ED840485F88C145F44EC1E05FAB40D03CE640D73450C1659CAB41E2EE32C18AB88B4197075541F0CFA1412B46B13E130A80BDBD6B513FA9778ABF183310412902A63ED55BDFBED9D185C12B55D4C1DEB82D40DD32C33E87F257BF45B3E9401FF322419B20213F4FF08341F5716ABFC6336F41D20033404D1588C05A79B6BF02123FC06CECAFC059B043BEF5B196C14F010AC03CDCE2BFACBE4D415C72D23DFC7E76C0502780C0207E11413ADAA1C0A39E15BF477D63C19E440541C345D63FEE0230BF69763FC0F7C28AC03D6200410F0003C1196C35BF8CBD8140D4FCD3C01A456941CAE62CC1DFFE65C032438CC0FAD727BFC8EADF3FC6123FC1988EA73F17D2943EB8DC8B3F1B3CAEC049BFC741F063203EF223A0C0EDFEFDBFB85C0DBFBBC00DC012B793BFA21557BFE31800418D8125C10C72C0BD4BAC963F604E5FBF20C293C1E58F1BC0A19768BF2DFBE53F50ECDE3F6A534AC0086957402FAD15C12B0242BE734354BF1C7127C050FFA0C025636F409ADAA2C0ABAD4CC120FE7A3FE696F4BFD751F0BF0AAF8AC02CB4F03F41BE02BF004C9AC167E31541636ED33FC826E4BD75D5A1C193CF21BFA0F20BC107F6BA3F69C4503FF2DD853E4BBC4D3FC29EF1BE3781814066EB8FC0760172C08A7CAFBFD2870841BCDA8E413A3EB3C0AC33C23FCE5F443F51FC213DB49F36411BCFB6BE4D6DAABC6ACFFEC0995110C0F558EB40FF7F31C149C729BF87022741126F2FC19839A4413ED972C02ACDC63FAA5E4BC09A879CBF48C56DBFEFA87BC0E999BB40C9245F40650A92BF24F33C4038D373C076D02FBD6A724A4115E5A03FE55F09C0F427084003E6D8400C482041A8F8D7C1EEC6733F289C9EBD9A0EF4407940853F9200A53EA2A745414B5508414F5FDB3E5BCA33C0361812C1A5F283BD491AE0BFDC48A0C0D516EB4052F190406D8116C1B42763BF29B0D8C0026420C275803E3F53609BC095B7D7BF7DF119BE4FA8CBBE3BEC60BD2526BCBE6C7F163FB3B6543F5AC20040085C49BF0485B3C076B02CBFC3149BC1DC26A940A13CC640B3CF98C07EA9193DD2D1E4BDBB1CBDC02137773FF6A053C123F0664008C4AEC0FE4A63C1BFAC06C089CAB13EC685DFC01B4B90BF7E22883E5DD69640B682D940C99171C16AF60EC1136B0440A7C295C01C4E9AC06C0878C10F6799C09FAC4240BBDEB140D9C76CC193C81940A3015E40891A3E401859C1BF28616941C7C9ACBFDB5A08C172F41541EE5D3E4112481340616AA441F91371C1993E7A3F9A93CE4095AACE404075123DC01DD640ACCA04C1A0B3A6410FD466403823CC4036F1FD400BD3CA40C2AC91C06923883E"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}