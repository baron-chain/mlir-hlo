// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<8x9xui8>
    %1 = call @expected() : () -> tensor<8x9xui8>
    %2 = call @cumprod(%0) : (tensor<8x9xui8>) -> tensor<8x9xui8>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<8x9xui8>, tensor<8x9xui8>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<8x9xui8> {
    %0 = stablehlo.constant dense<[[2, 1, 2, 4, 6, 0, 2, 6, 4], [2, 1, 1, 1, 0, 9, 4, 1, 0], [0, 0, 1, 1, 4, 1, 0, 2, 5], [0, 0, 3, 2, 3, 0, 2, 2, 3], [4, 0, 2, 1, 0, 0, 4, 1, 2], [5, 0, 4, 1, 1, 0, 2, 2, 1], [2, 4, 1, 0, 1, 3, 3, 1, 3], [1, 1, 0, 2, 4, 2, 0, 1, 1]]> : tensor<8x9xui8>
    return %0 : tensor<8x9xui8>
  }
  func.func private @expected() -> tensor<8x9xui8> {
    %0 = stablehlo.constant dense<[[2, 1, 2, 4, 6, 0, 2, 6, 4], [4, 1, 2, 4, 0, 0, 8, 6, 0], [0, 0, 2, 4, 0, 0, 0, 12, 0], [0, 0, 6, 8, 0, 0, 0, 24, 0], [0, 0, 12, 8, 0, 0, 0, 24, 0], [0, 0, 48, 8, 0, 0, 0, 48, 0], [0, 0, 48, 0, 0, 0, 0, 48, 0], [0, 0, 0, 0, 0, 0, 0, 48, 0]]> : tensor<8x9xui8>
    return %0 : tensor<8x9xui8>
  }
  func.func private @cumprod(%arg0: tensor<8x9xui8>) -> tensor<8x9xui8> {
    %0 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 7, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 2, 1>} : (tensor<8x9xui8>) -> tensor<4x9xui8>
    %1 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 8, 9>, start_indices = array<i64: 1, 0>, strides = array<i64: 2, 1>} : (tensor<8x9xui8>) -> tensor<4x9xui8>
    %2 = stablehlo.multiply %0, %1 : tensor<4x9xui8>
    %3 = "stablehlo.slice"(%2) {limit_indices = array<i64: 3, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 2, 1>} : (tensor<4x9xui8>) -> tensor<2x9xui8>
    %4 = "stablehlo.slice"(%2) {limit_indices = array<i64: 4, 9>, start_indices = array<i64: 1, 0>, strides = array<i64: 2, 1>} : (tensor<4x9xui8>) -> tensor<2x9xui8>
    %5 = stablehlo.multiply %3, %4 : tensor<2x9xui8>
    %6 = "stablehlo.slice"(%5) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 2, 1>} : (tensor<2x9xui8>) -> tensor<1x9xui8>
    %7 = "stablehlo.slice"(%5) {limit_indices = array<i64: 2, 9>, start_indices = array<i64: 1, 0>, strides = array<i64: 2, 1>} : (tensor<2x9xui8>) -> tensor<1x9xui8>
    %8 = stablehlo.multiply %6, %7 : tensor<1x9xui8>
    %9 = "stablehlo.slice"(%8) {limit_indices = array<i64: 0, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<1x9xui8>) -> tensor<0x9xui8>
    %10 = "stablehlo.slice"(%5) {limit_indices = array<i64: 2, 9>, start_indices = array<i64: 2, 0>, strides = array<i64: 2, 1>} : (tensor<2x9xui8>) -> tensor<0x9xui8>
    %11 = stablehlo.multiply %9, %10 : tensor<0x9xui8>
    %12 = "stablehlo.slice"(%5) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<2x9xui8>) -> tensor<1x9xui8>
    %13 = stablehlo.concatenate %12, %11, dim = 0 : (tensor<1x9xui8>, tensor<0x9xui8>) -> tensor<1x9xui8>
    %14 = stablehlo.constant dense<0> : tensor<ui8>
    %15 = stablehlo.pad %13, %14, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<1x9xui8>, tensor<ui8>) -> tensor<2x9xui8>
    %16 = stablehlo.constant dense<0> : tensor<ui8>
    %17 = stablehlo.pad %8, %16, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<1x9xui8>, tensor<ui8>) -> tensor<2x9xui8>
    %18 = stablehlo.add %15, %17 : tensor<2x9xui8>
    %19 = "stablehlo.slice"(%18) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<2x9xui8>) -> tensor<1x9xui8>
    %20 = "stablehlo.slice"(%2) {limit_indices = array<i64: 4, 9>, start_indices = array<i64: 2, 0>, strides = array<i64: 2, 1>} : (tensor<4x9xui8>) -> tensor<1x9xui8>
    %21 = stablehlo.multiply %19, %20 : tensor<1x9xui8>
    %22 = "stablehlo.slice"(%2) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<4x9xui8>) -> tensor<1x9xui8>
    %23 = stablehlo.concatenate %22, %21, dim = 0 : (tensor<1x9xui8>, tensor<1x9xui8>) -> tensor<2x9xui8>
    %24 = stablehlo.constant dense<0> : tensor<ui8>
    %25 = stablehlo.pad %23, %24, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<2x9xui8>, tensor<ui8>) -> tensor<4x9xui8>
    %26 = stablehlo.constant dense<0> : tensor<ui8>
    %27 = stablehlo.pad %18, %26, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<2x9xui8>, tensor<ui8>) -> tensor<4x9xui8>
    %28 = stablehlo.add %25, %27 : tensor<4x9xui8>
    %29 = "stablehlo.slice"(%28) {limit_indices = array<i64: 3, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<4x9xui8>) -> tensor<3x9xui8>
    %30 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 8, 9>, start_indices = array<i64: 2, 0>, strides = array<i64: 2, 1>} : (tensor<8x9xui8>) -> tensor<3x9xui8>
    %31 = stablehlo.multiply %29, %30 : tensor<3x9xui8>
    %32 = "stablehlo.slice"(%arg0) {limit_indices = array<i64: 1, 9>, start_indices = array<i64: 0, 0>, strides = array<i64: 1, 1>} : (tensor<8x9xui8>) -> tensor<1x9xui8>
    %33 = stablehlo.concatenate %32, %31, dim = 0 : (tensor<1x9xui8>, tensor<3x9xui8>) -> tensor<4x9xui8>
    %34 = stablehlo.constant dense<0> : tensor<ui8>
    %35 = stablehlo.pad %33, %34, low = [0, 0], high = [1, 0], interior = [1, 0] : (tensor<4x9xui8>, tensor<ui8>) -> tensor<8x9xui8>
    %36 = stablehlo.constant dense<0> : tensor<ui8>
    %37 = stablehlo.pad %28, %36, low = [1, 0], high = [0, 0], interior = [1, 0] : (tensor<4x9xui8>, tensor<ui8>) -> tensor<8x9xui8>
    %38 = stablehlo.add %35, %37 : tensor<8x9xui8>
    return %38 : tensor<8x9xui8>
  }
}
