; Instruction.s : 説明
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

; 説明を表示する
;
_Instruction::

    ; レジスタの保存

    ; 背景の表示
    call    _BackClear

    ; 処理の更新
    ld      hl, #InstructionReadContent
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰

    ; 終了
    ret

; 説明を読む
;
InstructionReadContent:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #instructionQueryString
    call    _GamePrint

    ; 選択の設定
    ld      hl, #instructionSelect
    ld      a, #0x02
    call    _GameSelect

    ; 背景の表示
    call    _BackLogo

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; いいえの選択
    call    _GameGetSelectItem
    jr      nc, 90$
    or      a
    jr      nz, 80$

    ; はいの選択

    ; ページの設定
    xor     a
    ld      (_game + GAME_COUNT), a

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : １ページの表示
20$:
    dec     a
    jr      nz, 30$

    ; 内容の表示
    ld      a, (_game + GAME_COUNT)
    add     a, a
    ld      e, a
    ld      d, #0x00
    ld      hl, #instructionContent
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ex      de, hl
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x03 : ページ送り
30$:
;   dec     a
;   jr      nz, 40$
    
    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; ページの更新
    ld      hl, #(_game + GAME_COUNT)
    inc     (hl)
    ld      a, (hl)
    cp      #0x0b
    jr      nc, 80$

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    dec     (hl)
    jr      90$
    
    ; 処理の更新
80$:
    ld      hl, #InstructionChoiceShootingLevel
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 説明の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 射撃の腕を選択する
;
InstructionChoiceShootingLevel:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #instructionShootingLevelQueryString
    call    _GamePrint

    ; 選択の設定
    ld      hl, #instructionShootingLevelSelect
    ld      a, #0x05
    call    _GameSelect

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; 選択の取得
    call    _GameGetSelectItem    
    jr      nc, 90$
    inc     a
    ld      (_value + VALUE_D9), a

    ; 処理の更新
    ld      hl, #InstructionNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 選択の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
InstructionNext:

    ; レジスタの保存

    ; 処理の更新
    ld      hl, #_Initialize
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 確認
;
instructionQueryString:

    .db     _HSE, _HTU, _HME, _H_I, _HWO, ____, _HYO, _HMI, _HMA, _HSU, _HKA, _QUE, _LRB, _HHA, _H_I, _SLA, _H_I, _H_I, _H_E, _RRB, 0x00

instructionSelect:

    .dw     instructionSelectString_0
    .dw     instructionSelectString_1

instructionSelectString_0:

    .db     _HHA, _H_I, 0x00

instructionSelectString_1:

    .db     _H_I, _H_I, _H_E, 0x00

; 内容
;
instructionContent:

    .dw     instructionContentString_0
    .dw     instructionContentString_1
    .dw     instructionContentString_2
    .dw     instructionContentString_3
    .dw     instructionContentString_4
    .dw     instructionContentString_5
    .dw     instructionContentString_6
    .dw     instructionContentString_7
    .dw     instructionContentString_8
    .dw     instructionContentString_9
    .dw     instructionContentString_10

instructionContentString_0:

    .db     _HKO, _HRE, _HHA, ____
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, _HNI, _H_O, _HKE, _HRU, ____
    .db     _KMI, _KSU, _KSN, _MNS, _KRI, _HKA, _HRA, _K_O, _KRE, _KKO, _KSN, _K_N, _HNI, _HTU, _H_U, _HSU, _KSN, _HRU
    .db     _K_O, _KRE, _KKO, _KSN, _K_N, _HKA, _H_I, _HTO, _KSN, _H_U, _HNO, _HTA, _HHI, _KSN, _HWO
    .db     _KSI, _KMI, _Kyu, _KRE, _MNS, _KTO, _HSI, _HTA, ____
    .db     _KHU, _KPS, _KRO, _KKU, _KSN, _KRA, _KMU, _HTE, _KSN, _HSU, _DOT, __LF
    .db     _H_A, _HNA, _HTA, _HNO, ___5, _HNI, _H_N, _HNO, _HKA, _HSO, _KSN, _HKU, _HHA
    .db     ___5, _MNS, ___6, _HKA, _HKE, _KSN, _HTU, _HKA, _HKE, _HTE, ____
    .db     ___2, ___0, ___4, ___0, _KMA, _K_I, _KRU, _HNI, _H_O, _HYO, _HHU, _KSN
    .db     _K_O, _KRE, _KKO, _KSN, _K_N, _HKA, _H_I, _HTO, _KSN, _H_U, _HWO, _HTA, _HHI, _KSN, _HSI, _HMA, _HSU, _DOT, _DOT, _DOT
    .db     _H_I, _HKI, _HNO, _HKO, _HRU, _HKO, _HTO, _HKA, _KSN, _HTE, _KSN, _HKI, _HRE, _HHA, _KSN, _HNO
    .db     _HHA, _HNA, _HSI, _HTE, _KSN, _HSU, _HKA, _KSN, _DOT, _DOT, _DOT
    .db     0x00

instructionContentString_1:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HHA, ____
    .db     _HTA, _HHI, _KSN, _HNO, _HTA, _HME, _HNI, _HTA, _HME, _HTA, _DOL, ___9, ___0, ___0, _HKA, _HRA
    .db     _DOL, ___2, ___0, ___0, _HWO, _HHA, _HRA, _Htu, _HTE, ____
    .db     _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HWO, _HKO, _H_U, _HNI, _Hyu, _H_U, _HSI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _HNO, _HKO, _Htu, _HTA, _HKE, _KSN, _H_N, _HKI, _H_N, _HHA, ____
    .db     _HTU, _HKI, _KSN, _HNO, _HSI, _Hyo, _H_U, _HHI, _H_N, _HNO, _HKO, _H_U, _HNI, _Hyu, _H_U, _HNI, _H_A, _HTE, _HMA, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

instructionContentString_2:

    .db     ____, __LF
    .db     _H_U, _HSI, _COL, __LF
    .db     ____, ____, _DOL, ___2, ___0, ___0, _MNS, _DOL, ___3, ___0, ___0, _HNO, _HHA, _H_N, _H_I, _HTE, _KSN, ____
    .db     _HKA, _H_E, _HMA, _HSU, _DOT, __LF
    .db     ____, ____, _HKI, _H_N, _HKA, _KSN, _HKU, _HKA, _KSN, _HTA, _HKA, _H_I, _HHO, _HTO, _KSN, ____
    .db     _HHA, _HYA, _HKU, _H_I, _HTO, _KSN, _H_U, _HSU, _HRU, _HKO, _HTO, _HKA, _KSN, _HTE, _KSN, _HKI, _HMA, _HSU, _DOT
    .db     0x00

instructionContentString_3:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _COL, __LF
    .db     ____, ____, _HTA, _HKU, _HSA, _H_N, _HMO, _HTU, _HHO, _HTO, _KSN, ____
    .db     _HHI, _KSN, _Hyo, _H_U, _HKI, _HNI, _HKA, _HKA, _HRI, _HNI, _HKU, _HKU, _HNA, _HRI, _HMA, _HSU, _DOT
    .db     0x00

instructionContentString_4:

    .db     _HTA, _KSN, _H_N, _HYA, _HKU, _COL, __LF
    .db     ____, ____, _DOL, ___1, _HTE, _KSN, ___5, ___0, _HHA, _KPS, _HTU, _HNO, _HTA, _KSN, _H_N, _HYA, _HKU, _HKA, _KSN, _HKA, _H_E, _HMA, _HSU, _DOT, __LF
    .db     ____, ____, _HKE, _HMO, _HNO, _HYA, _HSA, _H_N, _HSO, _KSN, _HKU, _HNI, _H_O, _HSO, _HWA, _HRE, _HTA, _HTO, _HKI, _HYA, ____
    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HWO, _HTI, _Hyo, _H_U, _HTA, __LF
    .db     ____, ____, _HTU, _HSU, _HRU, _HTA, _HME, _HNO, _HKA, _HRI, _HWO, _HSU, _HRU, _HTO, _HKI, _HNI, ____
    .db     _HHI, _HTU, _HYO, _H_U, _HTE, _KSN, _HSU, _DOT
    .db     0x00

instructionContentString_5:

    .db     _H_I, _HRU, _H_I, _COL, __LF
    .db     ____, ____, _HYA, _HMA, _HNO, _HSA, _HMU, _HSA, _HNI, _HTA, _H_E, _HRU, _HTA, _HME, _HNI, ____
    .db     _HTO, _HKU, _HNI, _HSI, _KSN, _Hyu, _H_U, _HYO, _H_U, _HTE, _KSN, _HSU, _DOT
    .db     0x00

instructionContentString_6:

    .db     _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, _COL, __LF
    .db     ____, ____, _H_I, _HRI, _Hyo, _H_U, _HHI, _H_N, _HYA, ____, _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HNO, _HHO, _HSI, _Hyu, _H_U, _HHU, _KSN, _HHI, _H_N, _HTE, _KSN, _HSU, _DOT
    .db     0x00

instructionContentString_7:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HHA, _HTA, _HHI, _KSN, _HWO, _HHA, _HSI, _KSN, _HME, _HRU, _HTA, _HME, _HNI, ____
    .db     _HMO, _Htu, _HTE, _H_I, _HRU, _HKE, _KSN, _H_N, _HKI, _H_N, _HNO, _HSU, _HHE, _KSN, _HTE, _HWO, _HTU, _HKI, _KSN, _HKO, _H_N, _HTE, _KSN, _HMO, _HYO, _H_I, _HSI, ____
    .db     _HTA, _HHI, _KSN, _HNO, _HTO, _HTI, _Hyu, _H_U, _HNI, _H_A, _HRU, _HKO, _H_U, _H_E, _HKI, _HSI, _KSN, _Hyo, _HTE, _KSN, _HTU, _HKA, _H_U, _HTA, _HME, _HNI, ____
    .db     _HTE, _HMO, _HTO, _HNI, _HNO, _HKO, _HSI, _HTE, _H_O, _H_I, _HTE, _HMO, _HKA, _HMA, _H_I, _HMA, _HSE, _H_N, _DOT
    .db     0x00

instructionContentString_8:

    .db     ____, __LF
    .db     _HTA, _HHI, _KSN, _HNO, _HTO, _HTI, _Hyu, _H_U, _HTE, _KSN, ____
    .db     _KRA, _K_I, _KHU, _KRU, _HWO, _HTU, _HKA, _H_U, _HHI, _HTU, _HYO, _H_U, _HKA, _KSN, _H_A, _HRU, _HTO, _HKI, _HHA, ____
    .db     _KKA, _MNS, _KSO, _KRU, _KKI, _MNS, _HWO, _H_O, _HSU, _HYO, _H_U, _HNI, _HSI, _HSI, _KSN, _HSA, _HRE, _HMA, _HSU, _DOT
    .db     _HSI, _HSI, _KSN, _HSA, _HRE, _HTA, _HTO, _H_O, _HRI, _HNI, _KKA, _MNS, _KSO, _KRU, _KKI, _MNS, _HWO, _H_O, _HSU, _HNO, _HKA, _KSN
    .db     _HHA, _HYA, _HKE, _HRE, _HHA, _KSN, _HHA, _HYA, _H_I, _HHO, _HTO, _KSN, ____
    .db     _HYO, _HRI, _HYO, _H_I, _HKE, _Htu, _HKA, _HKA, _KSN, _H_E, _HRA, _HRE, _HMA, _HSU, _DOT
    .db     0x00

instructionContentString_9:

    .db     ____, __LF
    .db     _HKO, _H_U, _HTO, _KSN, _H_U, _HWO, _H_E, _HRA, _HHU, _KSN, _HTO, _HKI, _HYA, ____
    .db     _HSU, _H_U, _HSI, _KSN, _HWO, _HNI, _Hyu, _H_U, _HRI, _Hyo, _HKU, _HSU, _HRU, _HTO, _HKI, _HHA, ____
    .db     _KKA, _MNS, _KSO, _KRU, _KKI, _MNS, _HTE, _KSN, _HHE, _H_N, _HKO, _H_U, _HSI, _HTE, ____
    .db     _KSU, _KHE, _KPS, _MNS, _KSU, _KKI, _MNS, _HTE, _KSN, _HKE, _Htu, _HTE, _H_I, _HSI, _HTE, _HKU, _HTA, _KSN, _HSA, _H_I, _DOT
    .db     0x00

instructionContentString_10:

    .db     ____, __LF
    .db     _HSO, _HRE, _HTE, _KSN, _HHA, ____, _HYO, _H_I, _HTA, _HHI, _KSN, _HWO, _DOT
    .db     0x00

instructionShootingLevelQueryString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HNO, _HSI, _Hya, _HKE, _KSN, _HKI, _HNO, ____, _H_U, _HTE, _KSN, _HMA, _H_E, _HHA, _QUE, __LF
    .db     _LRB, ___1, _RRB, _HSI, _Hya, _HKE, _KSN, _HKI, _HNO, _HME, _H_I, _HSI, _KSN, _H_N, __LF
    .db     _LRB, ___2, _RRB, _H_I, _H_I, _H_U, _HTE, _KSN, _HWO, _HMO, _Htu, _HTE, _H_I, _HRU, __LF
    .db     _LRB, ___3, _RRB, _HMA, _H_A, _HMA, _H_A, _HNA, _H_U, _HTE, _KSN, _HMA, _H_E, __LF
    .db     _LRB, ___4, _RRB, _HMO, _Htu, _HTO, _HRE, _H_N, _HSI, _Hyu, _H_U, _HKA, _KSN, _HHI, _HTU, _HYO, _H_U, __LF
    .db     _LRB, ___5, _RRB, _HHI, _HSA, _KSN, _HKA, _KSN, _HHU, _HRU, _H_E, _HRU, _HKU, _HRA, _H_I, __LF
    .db     _HKO, _HRE, _HRA, _HKA, _HRA, _H_E, _HRA, _H_N, _HTE, _KSN, _HKU, _HTA, _KSN, _HSA, _H_I, _DOT, __LF
    .db     _HSI, _Hya, _HKE, _KSN, _HKI, _HKA, _KSN, _H_U, _HMA, _H_I, _HHO, _HTO, _KSN, ____
    .db     _HYO, _HRI, _HHA, _HYA, _HKU, _HSE, _H_I, _HKO, _H_U, _HSU, _HRU, _HHI, _HTU, _HYO, _H_U, _HKA, _KSN, _H_A, _HRI, _HMA, _HSU, _DOT
    .db     0x00

instructionShootingLevelSelect:

    .dw     instructionShootingLevelSelectString_0
    .dw     instructionShootingLevelSelectString_1
    .dw     instructionShootingLevelSelectString_2
    .dw     instructionShootingLevelSelectString_3
    .dw     instructionShootingLevelSelectString_4

instructionShootingLevelSelectString_0:

    .db     _HSI, _Hya, _HKE, _KSN, _HKI, _HNO, _HME, _H_I, _HSI, _KSN, _H_N, 0x00

instructionShootingLevelSelectString_1:

    .db     _H_I, _H_I, _H_U, _HTE, _KSN, _HWO, _HMO, _Htu, _HTE, _H_I, _HRU, 0x00

instructionShootingLevelSelectString_2:

    .db     _HMA, _H_A, _HMA, _H_A, _HNA, _H_U, _HTE, _KSN, _HMA, _H_E, 0x00

instructionShootingLevelSelectString_3:

    .db     _HMO, _Htu, _HTO, _HRE, _H_N, _HSI, _Hyu, _H_U, _HKA, _KSN, _HHI, _HTU, _HYO, _H_U, 0x00

instructionShootingLevelSelectString_4:

    .db     _HHI, _HSA, _KSN, _HKA, _KSN, _HHU, _HRU, _H_E, _HRU, _HKU, _HRA, _H_I, 0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

