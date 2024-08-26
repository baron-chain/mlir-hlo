// RUN: stablehlo-translate --interpret -split-input-file %s

module attributes {jax.uses_shape_polymorphism = true} {
  func.func @main() -> tensor<20x20xf32> {
    %cst = stablehlo.constant dense<"0x68EF89BF9D39A03F4408B4BE9E372AC0C6CB48BFF9B665C06E25C040067EAB40062B1E40B05484402B049A40A09C14BF90E912C0C7998AC04D6B044057212340806BD13F4165993EEE633BC0DADA64C0FDE95E3F81729B40C0E91240E4F93F3F24B7F4BF430FD13F695096BF190EBDC0175B3640050F5CC05B32F93F98782A4026248DC0905E8DC0A244F23F7DDC4D4036970CBFB540004019CC9DC0D42618405B2CD2C04F8AAE3F0FB5F0BF357D09404FFBB43F5970E0BE985169BEFD7D0EC0C372F6BF90FEB5BF85F81A4073F20BC0F368BA3F5A37F2BF6802684083D7C7BFA888EB3EF61B33407A230FBFADD6BC3D859EA33FC1EBE6BDDAE7C7C0FA30F13F8E181240BC84C73F8EC0F4BF4B5900C02EC4BE40803E46C0009C953E369B3DC092ED22C00E620740E1800540CA55B23E76F409407BE2F8BFCA9ECDC0F3F4ADBF05F412C1B521A4C0DC118CC0B3FF893F648C7AC0AC8341C0FD67B8BD7B6A7DC04455533F84ED77BD9AFD9DC0B9BB91C0468C7ABFF7667DC082237240A4BD6640189576C0860A254028D2A2C0371232BFCCB4B93EADD8B4BFD4F4DCBF2824733F55525A40F7CBF23E7E81B5C0C114DE3F1E9AA23F987BB4C0FDF53A3FED42A040FD57FDC0D9F14E40983293C027650A4059BC44BBF2F6183FD72549C047368BBE0E26C4BFB4A224C001168140E42711C0EFDECFBFF3670741F65F91C011AD42405628D13F76C83D404902C9C0C377C33FB3E02E3F204E79BF778409C0C183C5BE8823B43EE7504B40E6C48E3F68D9B3BF8B9A86C0434219401ACF8A40AF14DAC04D365CC03A0083C0AFED96BF938E6640CF4C8540B087414089DF13C0A2E23C40A32A843F8E013E3FBB6DC2BF0699DB4074E02340A3D238C038AE133FC61AA53F56039240A48301C16792DCC02D602D3F41581CC090C933C09B4E7DC0F75D5C3F29CC2240F681F33EC386C1BF6C0EC44033AB49C01D96B5C01B6898409E6192C0FE776AC0277A22C02210A2400B45FC3F527F85C0291D753F7F8F34C028AC8CC0B05DBC4047ED0BBF84D09C3F7C12DFBD32B2093FC46DF4BF73AA5940FBE524406E4EA4BE23DD92402C1010C0E2562B40B12F9F3E805ED43F18360A40F50773C07B6B4DC04F5EE53E8658ACBE47828D407BB088407A1192402357A9BFE2913840AD2E32400931CCBF4C2F993F45E39040EDF3B6BFB7FB4840F38FB0402BF220407A11CC405EDEBD40C86684BEA6371EBFE46005C0486821C0FB20124041E91B406B189DC0BD414A4086348C40CFDDBDBE5F732DC0F30CC9C0A71A9BBE0C8C0FC0EC0E34C0A73E42C0B7BE8C3F99F50F404F7F81401EDEEABFBABB8C40F3B1FA3F163434BFA2AD76C06CE4594009A34540541C6EC0B3701B3D8E155FC0144999BF25D990C0C11705403923FBBF82ECCFBFBC24C3BF061BA33EE04251406A27103F880F39BF2C2B61C0EABDC2BF9261FEBED7D643C0EF3AD73FDB9F973FC9CD0940D0A9A3C044D6CC4031AFBDBF315B20402A11903FF0C4CBC07B0F14BFC5BED23D4D54124055FD9F3F093358406039E8BF70F8BDBE639D5EC025B22C40D658853FB9870A40F4A197C078229E3DAFBBB140FF9CC03F2FEF99403B4DD1BE33E20EC0CFFBC740AFD19C3FA390BD40DF038DBFDE4975C0FF502F40F9089140B383A53F343E2BBF0D9DD5BF1FC42A4004B388C05E4E46C0B89B3CBD93850A40C76768405CB002BF8CD7DAC06DFABABF668DB4C05B368A40055357C05F528540AD0679C06A6D443FF80433C0AD7925BF2A4B4C402DD94C4029F41B40C5147A40D34E0DC00A5D30409F795E403DF0B040F7AFABC00E4E5DC0C9CDEBBF8C6120BFFD28D84048EA853F8C3C554070096BBC2C3177C06DDA0F40FD18BABFD67507C055A9B8C0F2AA6DC03C28D2BF336A5FC0C57A593FA07CE73F5FDF18BE6BB572C019DF93C0C8EC053F2F6D4040D76AF6C0824AF63FE14ACCBF6F41603F162DCDBF6EDA743F22ECB14081E30B40405401C05BEF9240F759DABF79B5C93FA702803FA682CE3F5CD0D53F7A2E18BF83A63EBF445077C0751A1CBFBD290AC0EE7C77BFABE796BE0753E43FE85305C07352DE3F4283D6C070B4803F1A4532C0471D1D403630973F7B389B40C47802BFA0F6274043792E3F7B222740A5EB09404CB38F40BBBA0EC034E4BA3E48BAB1BF893EA1C07D956840B59FA7C0E40A1C3E48F7893FB3501D409E96863E8021334033CF673EF0F4CE3F69264CC0087AA4BF70B369C0F32385C0"> : tensor<20x20xf32>
    %cst_0 = stablehlo.constant dense<"0x00000000D3FF7F3F00000000000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3FD3FF7F3FD3FF7F3F000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3F738B0B3F0000000000000000C5EE6E3FD3FF7F3FD3FF7F3FB7DD5D3F00000000D3FF7F3F0000000000000000D3FF7F3F00000000D3FF7F3FD3FF7F3F0000000000000000D3FF7F3FD3FF7F3F00000000D3FF7F3F00000000D3FF7F3F00000000D3FF7F3F00000000D3FF7F3FD3FF7F3F0000000000000000000000000000000000000000D3FF7F3F00000000D3FF7F3F00000000D3FF7F3F000000008FAD2D3FD3FF7F3F00000000819C9C3ED3FF7F3F0000000000000000D3FF7F3FD3FF7F3FD3FF7F3F0000000000000000D3FF7F3F00000000728A0A3F0000000000000000D3FF7F3FD3FF7F3F7D97173FD3FF7F3F000000000000000000000000000000000000000000000000D3FF7F3F00000000000000000000000000000000C0E8683F0000000000000000000000000000000000000000D3FF7F3FD3FF7F3F00000000D3FF7F3F00000000000000007F99193F0000000000000000CDF8783FD3FF7F3F92B0303F00000000D3FF7F3FD3FF7F3F00000000B5DA5A3FD3FF7F3F00000000D3FF7F3F00000000D3FF7F3F00000000A3C5453F00000000000000000000000000000000D3FF7F3F0000000000000000D3FF7F3F00000000D3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3FAFD3533F0000000000000000000000007D97173FD3FF7F3FD3FF7F3F0000000000000000D3FF7F3FD3FF7F3F00000000000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3FB6DC5C3F00000000D3FF7F3FD3FF7F3F00000000A1C2423FD3FF7F3FD3FF7F3F0000000000000000AED2523F000000000000000000000000C4ED6D3FD3FF7F3F92B0303F00000000D3FF7F3F0000000000000000D3FF7F3F000000000000000000000000D3FF7F3FD3FF7F3F00000000CEF9793F0000000000000000D3FF7F3F00000000D3FF7F3F000000009BBB3B3F00000000D3FF7F3FD3FF7F3F00000000D3FF7F3F00000000D3FF7F3F768E0E3FD3FF7F3FD3FF7F3F00000000000000008DAA2A3F00000000D3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3FD3FF7F3FD3FF7F3FD3FF7F3F00000000000000000000000000000000D3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3F00000000000000000000000000000000000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3F0000000000000000D3FF7F3FD3FF7F3F00000000A6C8483E000000000000000000000000D3FF7F3F0000000000000000000000007790103FD3FF7F3F9FC0403F0000000000000000000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3F00000000D3FF7F3FD3FF7F3F000000000000000086A2A23ED3FF7F3FD3FF7F3FD3FF7F3F000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3F00000000768E8E3ED3FF7F3FD3FF7F3FD3FF7F3F0000000000000000D3FF7F3FD3FF7F3FD3FF7F3F0000000000000000D3FF7F3FD3FF7F3FD3FF7F3F0000000000000000D3FF7F3F000000000000000000000000D3FF7F3FD3FF7F3F00000000000000000000000000000000D3FF7F3F00000000D3FF7F3F00000000BAE0603F0000000000000000D3FF7F3FD3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3FD3FF7F3FD3FF7F3F00000000000000000000000000000000D3FF7F3FD3FF7F3FD3FF7F3F0000000000000000D3FF7F3F000000000000000000000000000000000000000000000000C3EB6B3FD3FF7F3F00000000000000000000000098B8383FD3FF7F3F00000000D3FF7F3F00000000C5EE6E3F00000000CEF9793FD3FF7F3FD3FF7F3F00000000D3FF7F3F00000000D3FF7F3FD3FF7F3FD3FF7F3FD3FF7F3F00000000000000000000000000000000000000000000000000000000D3FF7F3F00000000D3FF7F3F00000000D3FF7F3F00000000D3FF7F3FD3FF7F3FD3FF7F3F00000000D3FF7F3FAFD3533FD3FF7F3FD3FF7F3FD3FF7F3F00000000809A1A3F0000000000000000D3FF7F3F00000000A6C8C83ED3FF7F3FD3FF7F3F6C83033FD3FF7F3FCAF4F43ED3FF7F3F00000000000000000000000000000000"> : tensor<20x20xf32>
    %0 = stablehlo.uniform_quantize %cst : (tensor<20x20xf32>) -> tensor<20x20x!quant.uniform<i8:f32, 0.0039215482917486456:-128>>
    %1 = stablehlo.sqrt %0 : (tensor<20x20x!quant.uniform<i8:f32, 0.0039215482917486456:-128>>) -> tensor<20x20x!quant.uniform<i8:f32, 0.0039215583427279601:-128>>
    %2 = stablehlo.uniform_dequantize %1 : (tensor<20x20x!quant.uniform<i8:f32, 0.0039215583427279601:-128>>) -> tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%cst_0, %2) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %2 : tensor<20x20xf32>
  }
}
