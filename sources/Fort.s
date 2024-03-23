; Fort.s : 交易所
;


; モジュール宣言
;
    .module Game

; 参照ファイル
;
    .include    "bios.inc"
    .include    "vdp.inc"
    .include    "System.inc"
    .include    "Sound.inc"
    .include    "Code.inc"
    .include    "App.inc"
    .include	"Game.inc"
    .include    "Value.inc"
    .include    "Back.inc"

; 外部変数宣言
;

; マクロの定義
;


; CODE 領域
;
    .area   _CODE

; 交易所に着く
;
_Fort::
    
    ; レジスタの保存
    
    ; 処理の更新
    ld      hl, #FortPurchaseFood
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 食料を購入する
;
FortPurchaseFood:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #fortFoodQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, (_value + VALUE_T_L)
    ld      de, #0
    call    _GameAmount

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 金額の入力
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; 数値の取得
    call    _GameGetAmountValue
    jr      nc, 90$

    ; 支払い
    ex      de, hl
    ld      hl, (_value + VALUE_T_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_T_L), hl

    ; 食料 = 金額 * 2/3
    ex      de, hl
    ld      a, #3
    call    _GameDiv
    add     hl, hl
    ld      de, (_value + VALUE_F_L)
    add     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 処理の更新
    ld      hl, #FortPurchaseAmmunition
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 購入の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 弾薬を購入する
;
FortPurchaseAmmunition:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #fortAmmunitionQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, (_value + VALUE_T_L)
    ld      de, #0
    call    _GameAmount

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 金額の入力
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; 数値の取得
    call    _GameGetAmountValue
    jr      nc, 90$

    ; 支払い
    ex      de, hl
    ld      hl, (_value + VALUE_T_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_T_L), hl

    ; 弾薬 = 金額 * 50 * 2/3
    ex      de, hl
    ld      a, #3
    call    _GameDiv
    add     hl, hl
    add     hl, hl
    ld      c, l
    ld      b, h
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, de
    add     hl, bc
    ld      de, (_value + VALUE_B_L)
    add     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 処理の更新
    ld      hl, #FortPurchaseClothing
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 購入の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 衣類を購入する
;
FortPurchaseClothing:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #fortClothingQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, (_value + VALUE_T_L)
    ld      de, #0
    call    _GameAmount

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 金額の入力
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; 数値の取得
    call    _GameGetAmountValue
    jr      nc, 90$

    ; 支払い
    ex      de, hl
    ld      hl, (_value + VALUE_T_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_T_L), hl

    ; 衣類 = 金額 * 2/3
    ex      de, hl
    ld      a, #3
    call    _GameDiv
    add     hl, hl
    ld      de, (_value + VALUE_C_L)
    add     hl, de
    ld      (_value + VALUE_C_L), hl

    ; 処理の更新
    ld      hl, #FortPurchaseSupply
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 購入の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 必需品を購入する
;
FortPurchaseSupply:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #fortSupplyQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, (_value + VALUE_T_L)
    ld      de, #0
    call    _GameAmount

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 金額の入力
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; 数値の取得
    call    _GameGetAmountValue
    jr      nc, 90$

    ; 支払い
    ex      de, hl
    ld      hl, (_value + VALUE_T_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_T_L), hl

    ; 必需品 = 金額 * 2/3
    ex      de, hl
    ld      a, #3
    call    _GameDiv
    add     hl, hl
    ld      de, (_value + VALUE_M1_L)
    add     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 処理の更新
    ld      hl, #FortNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 購入の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
FortNext:
    
    ; レジスタの保存

    ; 距離の更新
    ld      hl, (_value + VALUE_M_L)
    ld      de, #45
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl
    
    ; 処理の更新
    ld      hl, #_Eat
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 食料
;
fortFoodQueryString:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 弾薬
;
fortAmmunitionQueryString:

    .db     _HTA, _KSN, _H_N, _HYA, _HKU, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 衣類
;
fortClothingQueryString:

    .db     _H_I, _HRU, _H_I, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 必需品
;
fortSupplyQueryString:

    .db     _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

