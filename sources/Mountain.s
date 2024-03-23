; Mountain.s : 山
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

; 山を超える
;
_Mountain::

    ; レジスタの保存
    
    ; 山は 950 マイルを超えてから
    ld      hl, (_value + VALUE_M_L)
    ld      de, #(950 + 1)
    or      a
    sbc     hl, de
    jr      nc, 10$
    ld      hl, #_Date
    jr      19$

    ; 険しい山道
10$:
    ld      hl, (_value + VALUE_M_L)
    ld      a, #100
    call    _GameDiv
    ld      de, #15
    or      a
    sbc     hl, de
    jr      nc, 11$
    ld      a, h
    cpl
    ld      h, a
    ld      a, l
    cpl
    ld      l, a
    inc     hl
11$:
    ld      a, l
    or      a
    jr      z, 13$
    ld      b, a
    ex      de, hl
    ld      hl, #0x0000
12$:
    add     hl, de
    djnz    12$
13$:
    ld      bc, #12
    add     hl, bc
    ld      a, l
    ld      bc, #(72 - 12)
    add     hl, bc
    call    _GameDiv
    ld      a, #9
    sub     l
    ld      e, a
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #10
    call    _GameDiv
    cp      e
    jr      nc, 14$
    ld      hl, #MountainRug
    jr      19$

    ; 山の状況
14$:
    ld      hl, #MountainSouthPass
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 険しい山道を進む
;
MountainRug:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 山の表示
    ld      hl, #mountainRugString
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

    ; アクシデントの発生
    call    _SystemGetRandom
    cp      #(256 * (10 + 1) / 100)
    jr      nc, 11$
    ld      hl, #MountainFindTrail
    jr      19$
11$:
    call    _SystemGetRandom
    cp      #(256 * (11 + 1) / 100)
    jr      nc, 12$
    ld      hl, #MountainDamageWagon
    jr      19$
12$:
    ld      hl, #MountainSlow
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 山の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 山道を探す
;
MountainFindTrail:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 山の表示
    ld      hl, #mountainFindTrailString
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
    ld      de, #60
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #MountainSouthPass
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 幌馬車が壊れる
;
MountainDamageWagon:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 山の表示
    ld      hl, #mountainDamageWagonString
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

    ; 必需品の紛失
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 弾薬の紛失
    ld      hl, (_value + VALUE_B_L)
    ld      de, #200
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #30
    call    _GameDiv
    add     a, #20
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #MountainSouthPass
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 慎重に進む
;
MountainSlow:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 山の表示
    ld      hl, #mountainSlowString
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
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #50
    call    _GameDiv
    add     a, #45
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #MountainSouthPass
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; イベントの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 南峠を越える
;
MountainSouthPass:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 南峠でのブリザード
    ld      a, (_value + VALUE_F1)
    or      a
    jr      nz, 08$
    ld      a, #1
    ld      (_value + VALUE_F1), a
    call    _SystemGetRandom
    cp      #(256 * 8 / 10)
    jr      nc, 00$
    ld      hl, #MountainBlizzard
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$
00$:

    ; 山の表示
    ld      hl, #mountainSouthPassString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
08$:
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

    ; 北峠でのブリザード
    ld      hl, (_value + VALUE_M_L)
    ld      de, #1700
    jr      c, 80$
    ld      a, (_value + VALUE_F2)
    or      a
    jr      nz, 80$
    ld      a, #1
    ld      (_value + VALUE_F2), a
    call    _SystemGetRandom
    cp      #(256 * 7 / 10)
    jr      nc, 11$
    ld      hl, #MountainBlizzard
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$
11$:
;   jr      80$

    ; 処理の更新
80$:
    ld      hl, #MountainNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 山の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; ブリザードにあう
;
MountainBlizzard:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 山の表示
    ld      hl, #mountainBlizzardString
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

    ; ブリザードの更新
    ld      a, #1
    ld      (_value + VALUE_L1), a

    ; 食料の紛失
    ld      hl, (_value + VALUE_F_L)
    ld      de, #25
    or      a
    sbc     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 必需品の紛失
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #10
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 弾薬の紛失
    ld      hl, (_value + VALUE_B_L)
    ld      de, #300
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 進行の停滞
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #40
    call    _GameDiv
    add     a, #30
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_M_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 衣類の確認
    call    _SystemGetRandom
    and     #0x01
    add     a, #18
    ld      e, a
    ld      d, #0x00
    ld      hl, (_value + VALUE_C_L)
    or      a
    sbc     hl, de
    jr      nc, 11$
    ld      hl, #_Illness
    jr      19$
11$:
    ld      hl, #MountainNext
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 山の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
MountainNext:

    ; レジスタの保存

    ; 山の確認
    ld      hl, (_value + VALUE_M_L)
    ld      de, #(950 + 1)
    or      a
    sbc     hl, de
    jr      nc, 10$
    ld      a, #1
    ld      (_value + VALUE_M9), a
10$:
    
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

; 険しい山道
;
mountainRugString:

    .db     ____, __LF
    .db     _HKE, _HWA, _HSI, _H_I, _HYA, _HMA, _HMI, _HTI, _HTE, _KSN, _HSU, _DOT
    .db     0x00

; 山道を探す
;
mountainFindTrailString:

    .db     _HTO, _H_O, _HRE, _HRU, _HMI, _HTI, _HWO, _HSA, _HKA, _HSU, _HNO, _HNI, _HTE, _HMA, _HTO, _KSN, _HRI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 幌馬車が壊れる
;
mountainDamageWagonString:

    .db     _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HKA, _KSN, ____, _HKO, _HWA, _HRE, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HSI, _Hyu, _H_U, _HRI, _HNI, _HSI, _KSN, _HKA, _H_N, _HWO, _HTO, _HRA, _HRE, ____
    .db     _H_I, _HKU, _HTU, _HKA, _HNO, _HMO, _HTI, _HMO, _HNO, _HMO, _HNA, _HKU, _HSI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 慎重に進む
;
mountainSlowString:

    .db     _H_A, _HNA, _HTA, _HHA, _HSI, _H_N, _HTI, _Hyo, _H_U, _HNI, ____, _HSU, _HSU, _HMI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 南峠を超える
;
mountainSouthPassString:

    .db     ____, __LF
    .db     _HYU, _HKI, _HMO, _HNA, _HKU, ____, _HHU, _KSN, _HSI, _KSN, _HNI, _HMI, _HNA, _HMI, _HTO, _H_O, _HKE, _KSN, _HWO, _HKO, _H_E, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; ブリザードにあう
;
mountainBlizzardString:

    .db     ____, __LF
    .db     _KHU, _KSN, _KRI, _KSA, _KSN, _MNS, _KTO, _KSN, _HTE, _KSN, _H_O, _HMO, _H_U, _HYO, _H_U, _HNI, _HSU, _HSU, _HME, _HSU, _KSN, ____
    .db     _H_I, _HKU, _HTU, _HKA, _HNO, _HMO, _HTI, _HMO, _HNO, _HMO, _H_U, _HSI, _HNA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; DATA 領域
;
    .area   _DATA

; 変数の定義
;

