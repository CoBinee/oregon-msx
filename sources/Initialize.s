; Initialize.s : 初期化
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

; 初期化する
;
_Initialize::
    
    ; レジスタの保存
    
    ; 変数の初期化
    ld      a, #-1
    ld      (_value + VALUE_X1), a
    xor     a
    ld      h, a
    ld      l, a
    ld      (_value + VALUE_K8), a
    ld      (_value + VALUE_S4), a
    ld      (_value + VALUE_F1), a
    ld      (_value + VALUE_F2), a
    ld      (_value + VALUE_M_L), hl
    ld      (_value + VALUE_M9), a
    ld      a, #-1
    ld      (_value + VALUE_D3), a

    ; 背景の表示
    call    _BackClear

    ; 処理の更新
    ld      hl, #InitializePurchaseOxen
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 牛を購入する
;
InitializePurchaseOxen:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #initializeOxenQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, #300
    ld      de, #200
    call    _GameAmount

    ; 背景の表示
    call    _BackFort

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
    ld      (_value + VALUE_A_L), hl

    ; 処理の更新
    ld      hl, #InitializePurchaseFood
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 購入の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 食料を購入する
;
InitializePurchaseFood:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #initializeFoodQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, #700
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
    ld      (_value + VALUE_F_L), hl

    ; 処理の更新
    ld      hl, #InitializePurchaseAmmunition
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
InitializePurchaseAmmunition:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #initializeAmmunitionQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, #700
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
    ld      (_value + VALUE_B_L), hl

    ; 処理の更新
    ld      hl, #InitializePurchaseClothing
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
InitializePurchaseClothing:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #initializeClothingQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, #700
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
    ld      (_value + VALUE_C_L), hl

    ; 処理の更新
    ld      hl, #InitializePurchaseSupply
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
InitializePurchaseSupply:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #initializeSupplyQueryString
    call    _GamePrint

    ; 数値の設定
    ld      hl, #700
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
    ld      (_value + VALUE_M1_L), hl

    ; 処理の更新
    ld      hl, #InitializeSpend
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 購入の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 購入した金額を支払う
;
InitializeSpend:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 総額の計算
    ld      hl, (_value + VALUE_A_L)
    ld      de, (_value + VALUE_F_L)
    add     hl, de
    ld      de, (_value + VALUE_B_L)
    add     hl, de
    ld      de, (_value + VALUE_C_L)
    add     hl, de
    ld      de, (_value + VALUE_M1_L)
    add     hl, de
    ld      de, #700
    ex      de, hl
    or      a
    sbc     hl, de
    ld      (_value + VALUE_T_L), hl
    jr      nc, 00$
    ld      hl, #initializeSpendOverString
    jr      01$
00$:
    call    _GameClearString
    ld      hl, #initializeSpendResultString_0
    call    _GameConcatString
    ld      hl, (_value + VALUE_T_L)
    ld      b, #0x00
    call    _GameConcatValue
    ld      hl, #initializeSpendResultString_1
    call    _GameConcatString
01$:
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; お金が足りない
    ld      a, (_value + VALUE_T_H)
    bit     #0x07, a
    jr      z, 11$

    ; もう一度購入する
    ld      hl, #InitializePurchaseOxen
    jr      19$

    ; お金が足りた
11$:

    ; 弾薬は $1 = 50 bullets
    ld      hl, (_value + VALUE_B_L)
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
    ld      (_value + VALUE_B_L), hl

    ; ゲームの開始
    ld      hl, #InitializeNext
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 支払いの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
InitializeNext:

    ; レジスタの保存

    ; 処理の更新
    ld      hl, #_Date
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 牛
;
initializeOxenQueryString:

    .db     ____, __LF
    .db     _H_U, _HSI, _HWO, _H_I, _HKU, _HRA, _HTE, _KSN, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 食料
;
initializeFoodQueryString:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 弾薬
;
initializeAmmunitionQueryString:

    .db     _HTA, _KSN, _H_N, _HYA, _HKU, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 衣類
;
initializeClothingQueryString:

    .db     _H_I, _HRU, _H_I, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 必需品
;
initializeSupplyQueryString:

    .db     _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, _HWO, _H_I, _HKU, _HRA, _HHU, _KSN, _H_N, ____, _HKA, _H_I, _HMA, _HSU, _HKA, _QUE, 0x00

; 支払い
;
initializeSpendOverString:

    .db     _HKA, _H_I, _HSU, _HKI, _KSN, _HTE, _KSN, _HSU, _DOT
    .db     _H_A, _HNA, _HTA, _HHA, _DOL, ___7, ___0, ___0, _HSI, _HKA, ____, _HMO, _Htu, _HTE, _H_I, _HMA, _HSE, _H_N, _DOT, __LF
    .db     _HMO, _H_U, _H_I, _HTI, _HTO, _KSN, ____, _HYA, _HRI, _HNA, _H_O, _HSI, _HMA, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

initializeSpendResultString_0:

    .db     _HSI, _HHA, _HRA, _H_I, _HKA, _KSN, _HSU, _H_N, _HTE, _KSN, ____, _HNO, _HKO, _HRI, _HHA, _DOL, 0x00

initializeSpendResultString_1:

    .db     _HNI, _HNA, _HRI, _HMA, _HSI, _HTA, _DOT, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

