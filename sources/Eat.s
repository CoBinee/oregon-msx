; Eat.s : 食事
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

; 食事をとる
;
_Eat::
    
    ; レジスタの保存

    ; 背景の表示
    call    _BackClear

    ; 食料の確認
    ld      hl, (_value + VALUE_F_L)
    bit     #0x07, h
    jr      nz, 10$
    ld      de, #13
    or      a
    sbc     hl, de
    jr      c, 10$
    ld      hl, #Eating
    jr      19$
10$:
    ld      hl, #EatStarvation
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret
    
; 食事する
;
Eating:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #eatQueryString
    call    _GamePrint

    ; 選択の設定
    ld      hl, #eatSelect
    ld      a, #3
    call    _GameSelect

    ; 背景の表示
    call    _BackTrail

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jp      nz, 20$

    ; 選択の取得
    call    _GameGetSelectItem
    jp      nc, 90$
    inc     a
    ld      (_value + VALUE_E), a

    ; 食事
    ld      e, a
    add     a, a
    add     a, a
    add     a, e
    add     a, #8
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_F_L)
    bit     #0x07, h
    jr      nz, 13$
    or      a
    sbc     hl, de
    jr      c, 13$
    ld      (_value + VALUE_F_L), hl

    ; 進む
    ld      hl, (_value + VALUE_A_L)
    ld      de, #220
    or      a
    sbc     hl, de
    jr      c, 11$
    ld      a, #5
    call    _GameDiv
    jr      12$
11$:
    ld      a, h
    cpl 
    ld      h, a
    ld      a, l
    cpl
    ld      l, a
    inc     hl
    ld      a, #5
    call    _GameDiv
    ld      a, h
    cpl 
    ld      h, a
    ld      a, l
    cpl
    ld      l, a
    inc     hl
12$:
    ex      de, hl
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #10
    call    _GameDiv
    ld      l, a
    ld      h, #0x00
    add     hl, de
    ld      de, #200
    add     hl, de
    ld      de, (_value + VALUE_M_L)
    add     hl, de
    ld      (_value + VALUE_M_L), hl

    ; フラグのクリア
    xor     a
    ld      (_value + VALUE_L1), a
    ld      (_value + VALUE_C1), a

    ; 処理の更新
    ld      hl, #EatNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$
    
    ; 食料が足りない
13$:
    ld      hl, #eatNoFoodString
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : ページ送り
20$:
;   dec     a
;   jr      nz, 30$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 状態の更新
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 食事の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 餓死する
;
EatStarvation:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 餓死の表示
    call    _DiePrintStarvation

    ; 初期化の完了
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

    ; 処理の更新
    ld      hl, #_Die
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 初期化の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
EatNext:

    ; レジスタの保存

    ; 処理の更新
    ld      hl, #_Rider
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 食事
;
eatQueryString:

    .db     ____, __LF
    .db     _HSI, _Hyo, _HKU, _HSI, _KSN, _HWO, _HTO, _KSN, _HNO, _HKU, _HRA, _H_I, ____, _HTO, _HRI, _HMA, _HSU, _HKA, _QUE
    .db     0x00

eatSelect:

    .dw     eatSelectString_0
    .dw     eatSelectString_1
    .dw     eatSelectString_2

eatSelectString_0:

    .db     _HSU, _HKO, _HSI, _HTA, _KSN, _HKE, 0x00

eatSelectString_1:

    .db     _HHO, _HTO, _KSN, _HHO, _HTO, _KSN, 0x00

eatSelectString_2:

    .db     _HTA, _HRA, _HHU, _HKU, 0x00

eatNoFoodString:

    .db     _HSI, _KSN, _Hyu, _H_U, _HHU, _KSN, _H_N, _HNA, _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HKA, _KSN, ____,_HTA, _HRI, _HMA, _HSE, _H_N
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

