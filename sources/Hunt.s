; Hunt.s : 狩り
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

; 狩りをする
;
_Hunt::
    
    ; レジスタの保存

    ; 処理の更新
    ld      hl, #Hunting
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret
    
; 狩る
;
Hunting:
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 射撃
    call    _GameBang

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 射撃
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; 射撃の監視
    call    _GameIsBang
    jr      nc, 90$

    ; 処理の更新
    ld      hl, #HuntResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$

    ; 狩りの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 狩りの成果を見せる
;
HuntResult:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jp      nz, 09$

    ; 成果別の処理
    ld      a, (_value + VALUE_B1_L)
    cp      #(1 + 0x01)
    jr      nc, 00$
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #6
    call    _GameDiv
    add     a, #52
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_F_L)
    add     hl, de
    ld      (_value + VALUE_F_L), hl
    call    _SystemGetRandom
    and     #0x03
    add     a, #10
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_B_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl
    ld      hl, #huntResultBestString
    jr      02$
00$:
    ld      hl, (_value + VALUE_B1_L)
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    ld      c, l
    ld      b, h
    add     hl, hl
    add     hl, bc
    add     hl, de
    ex      de, hl
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #100
    call    _GameDiv
    ld      l, a
    ld      h, #0x00
    or      a
    sbc     hl, de
    jr      c, 01$
    ld      a, (_value + VALUE_B1_L)
    add     a, a
    sub     #48
    neg
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_F_L)
    add     hl, de
    ld      (_value + VALUE_F_L), hl
    ld      a, (_value + VALUE_B1_L)
    ld      e, a
    add     a, a
    add     a, e
    add     a, #10
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_B_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl
    ld      hl, #huntResultGoodString
    jr      02$
01$:
    ld      hl, #huntResultPoorString
;   jr      02$
02$:
    call    _GamePrint
    call    _GameFeed

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
    ld      hl, #HuntNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 成果の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
HuntNext:
    
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

; 成果
;
huntResultBestString:

    .db     _HMI, _HKE, _H_N, _HWO, _H_U, _HTI, _HNU, _H_I, _HTA, ____, _HMI, _HKO, _KSN, _HTO, _HNA, _H_I, _HTI, _HKE, _KSN, _HKI, _HTE, _KSN, _HSU, _EXC, __LF
    .db     _HKO, _H_N, _HYA, _HHA, _H_O, _HNA, _HKA, _H_I, _Htu, _HHA, _KPS, _H_I, ____, _HTA, _HHE, _KSN, _HRA, _HRE, _HRU, _HTE, _KSN, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

huntResultGoodString:

    .db     _KNA, _K_I, _KSU, _KSI, _Kyo, _Ktu, _KTO, _DOT
    .db     _HKO, _H_N, _HYA, _HHA, _HYO, _H_I, _HSI, _Hyo, _HKU, _HSI, _KSN, _HNI, ____, _H_A, _HRI, _HTU, _HKE, _HSO, _H_U, _HTE, _KSN, _HSU, _DOT
    .db     0x00

huntResultPoorString:

    .db     _HNE, _HRA, _H_I, _HWO, _HHA, _HSU, _KSN, _HSI, _HTE, _HSI, _HMA, _H_I, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_A, _HNA, _HTA, _HNO, _HYU, _H_U, _HSI, _Hyo, _HKU, _HKA, _KSN, ____, _HNI, _HKE, _KSN, _HTE, _HYU, _HKU, _DOT, _DOT, _DOT
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

