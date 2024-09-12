// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x20xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<3x4x5xf32>
    %1 = call @expected() : () -> tensor<3x20xf32>
    %2 = stablehlo.transpose %0, dims = [2, 0, 1] : (tensor<3x4x5xf32>) -> tensor<5x3x4xf32>
    %3 = stablehlo.reshape %2 : (tensor<5x3x4xf32>) -> tensor<3x20xf32>
    stablehlo.custom_call @check.expect_close(%3, %1) {has_side_effect = true} : (tensor<3x20xf32>, tensor<3x20xf32>) -> ()
    return %3 : tensor<3x20xf32>
  }
  func.func private @inputs() -> (tensor<3x4x5xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[[-3.71634793, 3.06628942, 3.3750329, 0.0790164768, 0.749681711], [-1.03424823, -3.27405071, -4.07794142, -3.116380e+00, -3.87919378], [-1.5739162, -2.27224565, 3.00124192, -4.49154043, -8.51527976], [-0.811006784, -2.84270644, -1.31332338, -3.555730e+00, -2.1702776]], [[-0.068111904, -3.50132775, 4.08764458, 0.265624493, 0.226424858], [2.72907567, 3.38302088, 4.45208836, -0.621724307, 2.48911405], [0.905898571, 2.38974261, -0.351971388, -6.9618926, -7.09324217], [3.21448612, 2.91625166, 5.150846, 0.797117292, -1.89348769]], [[-1.55605543, -4.92558718, -4.17480659, -2.85117483, 0.637217342], [-0.582484186, 0.191065878, 5.91832352, -1.00708461, 1.06471837], [1.57875049, 1.84584713, -3.27456975, -3.27177668, 4.59196091], [-4.29085302, 6.65334368, 5.1518755, 1.13068402, 1.39383936]]]> : tensor<3x4x5xf32>
    return %cst : tensor<3x4x5xf32>
  }
  func.func private @expected() -> (tensor<3x20xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-3.71634793, -1.03424823, -1.5739162, -0.811006784, -0.068111904, 2.72907567, 0.905898571, 3.21448612, -1.55605543, -0.582484186, 1.57875049, -4.29085302, 3.06628942, -3.27405071, -2.27224565, -2.84270644, -3.50132775, 3.38302088, 2.38974261, 2.91625166], [-4.92558718, 0.191065878, 1.84584713, 6.65334368, 3.3750329, -4.07794142, 3.00124192, -1.31332338, 4.08764458, 4.45208836, -0.351971388, 5.150846, -4.17480659, 5.91832352, -3.27456975, 5.1518755, 0.0790164768, -3.116380e+00, -4.49154043, -3.555730e+00], [0.265624493, -0.621724307, -6.9618926, 0.797117292, -2.85117483, -1.00708461, -3.27177668, 1.13068402, 0.749681711, -3.87919378, -8.51527976, -2.1702776, 0.226424858, 2.48911405, -7.09324217, -1.89348769, 0.637217342, 1.06471837, 4.59196091, 1.39383936]]> : tensor<3x20xf32>
    return %cst : tensor<3x20xf32>
  }
}