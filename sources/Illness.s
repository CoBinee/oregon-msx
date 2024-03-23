; Illness.s : 病気
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

; 病に冒される
;
_Illness::

    ; レジスタの保存
    
    ; 病の取得
    ld      a, (_value + VALUE_E)
    dec     a
    ld      e, a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, a
    add     a, e
    add     a, e
    add     a, e
    add     a, #10
    ld      e, a
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #100
    call    _GameDiv
    cp      e
    jr      c, 10$
    ld      a, (_value + VALUE_E)
    dec     a
    add     a, a
    add     a, a
    ld      hl, #40
    call    _GameDiv
    ld      a, #100
    sub     l
    ld      e, a
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #100
    call    _GameDiv
    cp      e
    jr      c, 11$
    ld      hl, #IllnessSerious
    jr      19$
10$:
    ld      hl, #IllnessMild
    jr      19$
11$:
    ld      hl, #IllnessBad
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 軽い病に冒される
;
IllnessMild:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 病の表示
    ld      hl, #illnessMildString
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

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 必需品の消費
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #2
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 処理の更新
    ld      hl, #IllnessNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 病の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 悪い病に冒される
;
IllnessBad:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 病の表示
    ld      hl, #illnessBadString
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

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 必需品の消費
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 処理の更新
    ld      hl, #IllnessNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 病の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 重い病に冒される
;
IllnessSerious:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 病の表示
    ld      hl, #illnessSeriousString
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

    ; 必需品の消費
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #2
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 病気フラグの更新
    ld      a, #1
    ld      (_value + VALUE_S4), a

    ; 処理の更新
    ld      hl, #IllnessNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 病の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 死亡する
;
IllnessDie:

    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 死因の表示
    call    _DiePrintNoMedicine

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

    ; 死亡の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
IllnessNext:

    ; レジスタの保存
    
    ; 処理の更新
    ld      a, (_value + VALUE_M1_H)
    bit     #0x07, a
    jr      z, 10$
    ld      hl, #IllnessDie
    jr      13$
10$:
    ld      a, (_value + VALUE_L1)
    or      a
    jr      z, 12$
    ld      hl, (_value + VALUE_M_L)
    ld      de, #(950 + 1)
    or      a
    sbc     hl, de
    jr      nc, 11$
    ld      a, #1
    ld      (_value + VALUE_M9), a
11$:
    ld      hl, #_Date
    jr      13$
12$:
    ld      hl, #_Mountain
;   jr      13$
13$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 病
;
illnessMildString:

    .db     _HKA, _HRU, _H_I, _HHI, _KSN, _Hyo, _H_U, _HKI, _HNI, ____, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HKU, _HSU, _HRI, _HWO, ____, _HTU, _HKA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

illnessBadString:

    .db     _HWA, _HRU, _H_I, _HHI, _KSN, _Hyo, _H_U, _HKI, _HNI, ____, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HKU, _HSU, _HRI, _HWO, ____, _HTU, _HKA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

illnessSeriousString:

    .db     _HKA, _HNA, _HRI, _H_O, _HMO, _H_I, _HHI, _KSN, _Hyo, _H_U, _HKI, _HNI, ____, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_I, _HSI, _Hya, _HNI, _HMI, _HSE, _HRU, _HMA, _HTE, _KSN, ____, _HSA, _HKI, _HNI, _HSU, _HSU, _HMU, _HKO, _HTO, _HHA, _HTE, _KSN, _HKI, _HMA, _HSE, _H_N, _DOT
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

