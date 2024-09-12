// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x3xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<3x3xf32>, tensor<3x3xf32>)
    %1 = call @expected() : () -> tensor<3x3xf32>
    %2 = stablehlo.minimum %0#0, %0#1 : tensor<3x3xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<3x3xf32>, tensor<3x3xf32>) -> ()
    return %2 : tensor<3x3xf32>
  }
  func.func private @inputs() -> (tensor<3x3xf32> {mhlo.layout_mode = "default"}, tensor<3x3xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[0x7FC00000, 0x7FC00000, 0x7FC00000], [0x7F800000, 0x7F800000, 0x7F800000], [0xFF800000, 0xFF800000, 0xFF800000]]> : tensor<3x3xf32>
    %cst_0 = stablehlo.constant dense<[[0x7FC00000, 0x7F800000, 0xFF800000], [0x7FC00000, 0x7F800000, 0xFF800000], [0x7FC00000, 0x7F800000, 0xFF800000]]> : tensor<3x3xf32>
    return %cst, %cst_0 : tensor<3x3xf32>, tensor<3x3xf32>
  }
  func.func private @expected() -> (tensor<3x3xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[0x7FC00000, 0x7FC00000, 0x7FC00000], [0x7FC00000, 0x7F800000, 0xFF800000], [0x7FC00000, 0xFF800000, 0xFF800000]]> : tensor<3x3xf32>
    return %cst : tensor<3x3xf32>
  }
}