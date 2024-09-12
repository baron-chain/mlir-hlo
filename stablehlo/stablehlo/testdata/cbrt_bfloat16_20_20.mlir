// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xbf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = stablehlo.cbrt %0 : tensor<20x20xbf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> ()
    return %2 : tensor<20x20xbf16>
  }
  func.func private @inputs() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x27C006C0D33FC9BF963F97BFF9BE8BBF763ECE3E9EC0044030BE9DBF39C02041D73F50BF11C08E40B3C036404FC01EC0B6BFABC0CABE6BC093403BC061C0D83FA33F04C1D83F9E40A2BE8E3FAEBF54404C4052C086C0AF40BD3F113FAABFD2BD0F40A0BFBA3F0F4020C019C0623D0BC0BCBF203F833F22C07B40C0C068BF18BFCCC0D4BD813E0B3E813FB1BF3BC0B53F943E304089C07EBD45C062C0124031BF3440B6BF973F2E3FBABFB33F8F40C540D5BEB23FF73EE0BDB83F51405A400CBEFE3E26C0A1406A3FC13F02C08AC0BF3FB13CAEBFD63E42BF863FCFC0694036C039C08EC0A040C63E17405FC0993FA23FFCBFACC0DFBF2CC07B3FF3409F40B140CDBF4C4019C0583F383F50407ABF0B40B0BEC6C0273F5940663FF83F9DBF26C055BF4AC0C7BFFF3F603FD13E3AC03A3F80BEE4BF573FA93E993FF7BD914032C033C0D7BCD34087C0E9BFB4BF044084C0FABC58BE87BF583DC3C095BF9DBEB93F9D4029C0C7BF754053BF9C3E9F3C3BC033C0F2BE8640E9BD8240883E783F0CC046C0DCBEC9BFC0BE56C036BFF43F9F3FA5BFC23F3CC0DBC001C032C0D8C0E73F8CC01440E33F843E70C0623C8E40E6BFA53FC9BE25400AC020405A3F59C0FCBF1FC015408A40444086BFB23F5FC0163FE23F6AC0EC3F6EC0893F42BF0C40CF4022BE92408940B6C0543FB2BCE6BF76BF513F10C0CB3FAF3F1FBE903F6AC07AC0DBBFA4BF264032406F3F753E953EC9BE4EBF133F6B40B3407E409CC07A40DFBFE53F53C03AC0EDBD04BEC43F5DC089BED5401DC181C08B40083FADC01740464019C08BC043BE41C07540ADC0E63F28404BC086C0903F4CC029C07FBF32C0C3BFA9BF043F653F4FBF2740143F64C046C0A9C07940BCBFCE400FC035404D40FA3F09400E401940B13FE6BF0DBF97BF7DC0183F41C0A93FA0C01FC083C0F2BE8EC00E40D040E2408E3E8F3ECB408840C8BF9DBF7840B4BE78C0353F33C05A3F23401EC0063FE1BF09C0B5BDD9404D4006BE4EC0923E8640043F17C02840644058BFA840EFBF923EB840563F013FC140073E0CC06CC03140B03F42404C40D3BE84C081C0374001C00640EF3F9D4083BF15C099404BBE1140E3BC1C407740D23E66BF"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
  func.func private @expected() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xB0BFA4BF973F95BF873F87BF49BF84BF1F3F3D3FDABFA33F0EBF89BFB6BF0A40983F6FBFA8BFD23FE3BFB53FBDBFADBF90BFE0BF3CBFC5BFD53FB7BFC3BF983F8B3F01C0983FDA3F2EBF853F8EBFBF3FBC3FBEBFCEBFE23F923F543F8DBFF0BEA73F8ABF913FA73FAEBFABBFC33EA6BF91BF5B3F813FAEBFCA3FE9BF78BF57BFEDBFF0BE223F043F803F8FBFB7BF903F293FB33FD0BFCBBEBABFC3BFA93F62BFB53F90BF873F613F91BF8F3FD33FEB3F3FBF8F3F493FF5BE903FBE3FC13F04BF4B3FB0BFDB3F783F933FA2BFD0BF923F8F3E8EBF3F3F69BF823FEEBFC53FB5BFB6BFD2BFDB3F3B3FAA3FC2BF883F8A3FA0BFE0BF9ABFB2BF7E3FFC3FDA3FE23F96BFBC3FABBF723F653FBE3F7EBFA63F33BFEBBF5E3FC03F773FA03F89BFB0BF71BFBCBF94BFA13F753F3E3FB7BF663F21BF9BBF723F313F883FFDBED43FB4BFB4BF98BEF03FCFBF9CBF8FBFA33FCDBFA0BE18BF82BFC03EEABF87BF2DBF913FDA3FB1BF94BFC83F70BF2C3F8A3EB7BFB4BF47BFCE3FF8BECC3F253F7D3FA6BFBBBF41BF95BF39BFBFBF64BF9F3F8A3F8BBF933FB7BFF3BFA2BFB4BFF2BF9C3FD1BFA93F9B3F233FC7BF763ED23F9CBF8B3F3BBFB03FA5BFAE3F733FC0BFA0BFADBFAA3FD03FBA3F82BF8F3FC2BF563F9B3FC5BF9D3FC6BF833F69BFA63FEE3F0ABFD43FD03FE4BF703F8FBE9CBF7DBF6F3FA8BF953F8E3F0ABF853FC5BFCABF99BF8BBFB03FB43F7A3F1F3F2A3F3BBF6EBF553FC53FE33FCB3FD9BFCA3F9ABF9B3FBFBFB7BFFABE01BF943FC1BF25BFF13F09C0CCBFD13F4F3FE1BFAA3FBB3FABBFD1BF13BFB9BFC83FE1BF9C3FB13FBCBFCEBF853FBCBFB1BF80BFB4BF93BF8CBF4D3F773F6EBFB03F553FC3BFBBBFDFBFC93F91BFEE3FA7BFB53FBD3FA03FA53FA73FAB3F8F3F9CBF52BF87BFCABF573FB9BF8C3FDBBFADBFCDBF47BFD2BFA73FEF3FF63F273F273FED3FCF3F95BF89BFC93F35BFC9BF643FB4BF733FAF3FADBF4E3F9ABFA5BFE4BEF23FBD3F02BFBDBF293FCE3F4D3FAABFB13FC33F72BFDE3F9EBF293FE53F713F4C3FE93F023FA6BFC6BFB43F8E3FB93FBC3F3FBFCDBFCCBFB63FA2BFA43F9E3FDA3F81BFAABFD83F15BFA83F9BBEAC3FC93F3E3F77BF"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
}