// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x50x3xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<32> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x50x3xf32>, tensor<1x3xf32>)
    %1 = call @expected() : () -> tensor<1x50x3xf32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %3 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) : (tensor<1x50x3xf32>, tensor<1xi64>, tensor<1x3xf32>) -> tensor<1x50x3xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<1x50x3xf32>, tensor<1x50x3xf32>) -> ()
    return %2 : tensor<1x50x3xf32>
  }
  func.func private @inputs() -> (tensor<1x50x3xf32> {mhlo.layout_mode = "default"}, tensor<1x3xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x3A2B8EC0D8BAAEBF3CE533C019F762BE651D9D404C2418BE06641D40987056C089B78640A68B853E0474EABF3E6F9A3DB72966403E8057BE307C1FBFFB0490BEFFE4A2BF8BDB52401943B23FEC8F543E33ECC3BF91EC86C0A36D91BF9F9174C023494AC084BB02C08D45D03F7C991D3F450C373FA28F01C00B2BB5BE9A12C13EB45F81BFC0EE91C0A7F5E0BF6F3F2340592BBFBFFE6718BF28485DBFCCDF8340CA912ABEC49E29C0D7E0424068123B40F72AEABFE6EF01C074CE093E61723741798BC8C01B470540BB459B3F26E83FBF7FC3ADC0C42D1AC09DF8DABFD05E8E4029367C405FE7B040F8C15CC0CCCA8CC0569EA23ED8E8B44097DD1E3E4DC7913F784B04400FCB57C0AC2B1E408FEB0340FC56F53FFC5B9E3F333D23C038F991BED4FF0DBFC7CCBBBF349CB53FB5B903403319AABE03512E3F14960540F0FE98BF253A58406F60ACC06445ADBF822B5CC05FC62FC0A36833BF2D039A40FE60D7409B6A28C0F4B28F3FD02E0240475D2A3FF26057BFC2FFF73FBECB40C0892423C0EC17943E315C3CC09EE908C0AC38C23FF3153CC08A94AA40A4BE83BF75D7B6406D7F9EC08A6E88BF3081F44098B886C02594F640456C7E3F6151C83FD5CA1CC05C24264080B40EC051D07540A42EAEBFDF32CD3FD362DEBE867256BF15C68E40F6138BBCF6EF22C0F2019EC0C19570BFA1112E40AE5745BF23A6C83FB428C6BF304043C0482EE33FFE8B52C08CB2C340789FF13FC21984BEB4AEA1C0D2C657C07AD587BE31901F3E0ACC82BFB99630C07C5E33BF1BD3B2407E15AABFE2683BC06BF7F5BF89FF4E40AED101404859F9BFE42C7EC0CC025D3F"> : tensor<1x50x3xf32>
    %cst_0 = stablehlo.constant dense<[[-0.910339772, -4.35830116, -1.38438165]]> : tensor<1x3xf32>
    return %cst, %cst_0 : tensor<1x50x3xf32>, tensor<1x3xf32>
  }
  func.func private @expected() -> (tensor<1x50x3xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x3A2B8EC0D8BAAEBF3CE533C019F762BE651D9D404C2418BE06641D40987056C089B78640A68B853E0474EABF3E6F9A3DB72966403E8057BE307C1FBFFB0490BEFFE4A2BF8BDB52401943B23FEC8F543E33ECC3BF91EC86C0A36D91BF9F9174C023494AC084BB02C08D45D03F7C991D3F450C373FA28F01C00B2BB5BE9A12C13EB45F81BFC0EE91C0A7F5E0BF6F3F2340592BBFBFFE6718BF28485DBFCCDF8340CA912ABEC49E29C0D7E0424068123B40F72AEABFE6EF01C074CE093E61723741798BC8C01B470540BB459B3F26E83FBF7FC3ADC0C42D1AC09DF8DABFD05E8E4029367C405FE7B040F8C15CC0CCCA8CC0569EA23ED8E8B44097DD1E3E4DC7913F784B04400FCB57C0AC2B1E408FEB0340FC56F53FFC5B9E3F333D23C038F991BED4FF0DBFC7CCBBBF349CB53FB5B903403319AABE03512E3F14960540F0FE98BF253A58406F60ACC06445ADBF822B5CC05FC62FC0A36833BF2D039A40FE60D7409B6A28C0F4B28F3FD02E0240475D2A3FF26057BFC2FFF73FBECB40C0892423C0EC17943E315C3CC06B33B1BFAC38C23FF3153CC08A94AA40A4BE83BF75D7B6406D7F9EC08A6E88BF3081F44098B886C02594F640456C7E3F6151C83FD5CA1CC05C24264080B40EC051D07540A42EAEBFDF32CD3FD362DEBE867256BF15C68E40F6138BBCF6EF22C0F2019EC0C19570BFA1112E40AE5745BF23A6C83FB428C6BF304043C0482EE33FFE8B52C08CB2C340789FF13FC21984BEB4AEA1C0D2C657C07AD587BE31901F3E0ACC82BFB99630C07C5E33BF1BD3B2407E15AABFE2683BC06BF7F5BF89FF4E40AED101404859F9BFE42C7EC0CC025D3F"> : tensor<1x50x3xf32>
    return %cst : tensor<1x50x3xf32>
  }
}