; Final.s : ゴール
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

; ゴールする
;
_Final::
    
    ; レジスタの保存

    ; 最後の移動距離の割合の取得
    ld      hl, (_value + VALUE_M_L)
    ld      de, (_value + VALUE_M2_L)
    or      a
    sbc     hl, de
    jr      z, 10$
    push    hl
    ld      hl, #2040
    or      a
    sbc     hl, de
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
    pop     de
    ld      a, e
    call    _GameDiv
    ld      a, l
    jr      19$
10$:
    xor     a
;   jr      19$
19$:
    ld      (_value + VALUE_F9), a  ; F9 = F9 * 100

    ; 食料の調整
    ld      a, (_value + VALUE_F9)
    ld      e, a
    ld      a, #100
    sub     e
    ld      e, a
    ld      d, #0x00
    ld      a, (_value + VALUE_E)
    ld      c, a
    add     a, a
    add     a, a
    add     a, c
    add     a, #8
    ld      b, a
    ld      hl, #0x0000
20$:
    add     hl, de
    djnz    20$
    ld      a, #100
    call    _GameDiv
    ld      de, (_value + VALUE_F_L)
    add     hl, de
    ld      (_value + VALUE_F_L), hl

    ; 背景の表示
    call    _BackClear

    ; 処理の更新
    ld      hl, #FinalArrive
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰

    ; 終了
    ret

; オレゴンに到着する
;
FinalArrive:
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 到着の表示
    ld      hl, #finalArriveString
    call    _GamePrint
    call    _GameFeed

    ; 背景の表示
    call    _BackOregon

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
    ld      hl, #FinalResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 到着の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 結果を表示する
;
FinalResult:
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 結果の表示
    call    _GameClearString
    call    700$
    call    80$
    call    _GameGetString
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
    jp      nc, 90$

    ; 処理の更新
    ld      hl, #FinalCongratulation
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jp      90$

    ; 日付の表示
700$:

    ; 経過日数の取得
    ld      a, (_value + VALUE_F9)
    ld      l, a
    ld      h, #0x00
    add     hl, hl
    ld      c, l
    ld      b, h
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, de
    add     hl, bc
    ld      a, #100
    call    _GameDiv
    ld      a, l
    ld      (_value + VALUE_F9), a

    ; 年
    ld      hl, #finalResultYearString
    call    _GameConcatString

    ; 月日
    ld      a, (_value + VALUE_D3)
    ld      l, a
    ld      h, #0x00
    add     hl, hl
    ld      c, l
    ld      b, h
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, de
    add     hl, bc
    ld      a, (_value + VALUE_F9)
    ld      e, a
    ld      d, #0x00
    add     hl, de
    ld      de, #(124 + 1)
    or      a
    sbc     hl, de
    jr      nc, 730$
    add     hl, de
    ld      de, #93
    or      a
    sbc     hl, de
    ld      e, l
    ld      hl, #finalResultMonthJulyString
    jr      739$
730$:
    add     hl, de
    ld      de, #(155 + 1)
    or      a
    sbc     hl, de
    jr      nc, 731$
    add     hl, de
    ld      de, #124
    or      a
    sbc     hl, de
    ld      e, l
    ld      hl, #finalResultMonthAugustString
    jr      739$
731$:
    add     hl, de
    ld      de, #(185 + 1)
    or      a
    sbc     hl, de
    jr      nc, 732$
    add     hl, de
    ld      de, #155
    or      a
    sbc     hl, de
    ld      e, l
    ld      hl, #finalResultMonthSeptemberString
    jr      739$
732$:
    add     hl, de
    ld      de, #(216 + 1)
    or      a
    sbc     hl, de
    jr      nc, 733$
    add     hl, de
    ld      de, #185
    or      a
    sbc     hl, de
    ld      e, l
    ld      hl, #finalResultMonthOctoberString
    jr      739$
733$:
    add     hl, de
    ld      de, #(246 + 1)
    or      a
    sbc     hl, de
    jr      nc, 734$
    add     hl, de
    ld      de, #216
    or      a
    sbc     hl, de
    ld      e, l
    ld      hl, #finalResultMonthNovemberString
    jr      739$
734$:
    add     hl, de
    ld      de, #246
    or      a
    sbc     hl, de
    ld      e, l
    ld      hl, #finalResultMonthDecemberString
;   jr      739$
739$:
    call    _GameConcatString
    ld      l, e
    ld      h, #0x00
    ld      b, h
    call    _GameConcatValue
    ld      hl, #finalResultDayString
    call    _GameConcatString

    ; 曜日
    ld      a, (_value + VALUE_F9)
    inc     a
    cp      #8
    jr      c, 740$
    sub     #7
740$:
    ld      (_value + VALUE_F9), a
    dec     a
    jr      nz, 741$
    ld      hl, #finalResultWeekdayMondayString
    jr      749$
741$:
    dec     a
    jr      nz, 742$
    ld      hl, #finalResultWeekdayTuesdayString
    jr      749$
742$:
    dec     a
    jr      nz, 743$
    ld      hl, #finalResultWeekdayWednesdayString
    jr      749$
743$:
    dec     a
    jr      nz, 744$
    ld      hl, #finalResultWeekdayThursdayString
    jr      749$
744$:
    dec     a
    jr      nz, 745$
    ld      hl, #finalResultWeekdayFridayString
    jr      749$
745$:
    dec     a
    jr      nz, 746$
    ld      hl, #finalResultWeekdaySaturdayString
    jr      749$
746$:
    ld      hl, #finalResultWeekdaySundayString
;   jr      749$
749$:
    call    _GameConcatString

    ; 日付の完了
    ret

    ; 所持品の表示
80$:
    ld      hl, (_value + VALUE_F_L)
    bit     #0x07, h
    jr      z, 81$
    ld      hl, #0x0000
81$:
    ld      (_value + VALUE_F_L), hl
    ld      hl, (_value + VALUE_B_L)
    bit     #0x07, h
    jr      z, 82$
    ld      hl, #0x0000
82$:
    ld      (_value + VALUE_B_L), hl
    ld      hl, (_value + VALUE_C_L)
    bit     #0x07, h
    jr      z, 83$
    ld      hl, #0x0000
83$:
    ld      (_value + VALUE_C_L), hl
    ld      hl, (_value + VALUE_M1_L)
    bit     #0x07, h
    jr      z, 84$
    ld      hl, #0x0000
84$:
    ld      (_value + VALUE_M1_L), hl
    ld      hl, (_value + VALUE_T_L)
    bit     #0x07, h
    jr      z, 85$
    ld      hl, #0x0000
85$:
    ld      (_value + VALUE_T_L), hl
    ld      hl, #finalResultItemString
    call    _GameConcatString
    ld      hl, #finalResultSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_F_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #finalResultSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_B_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #finalResultSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_C_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #finalResultSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_M1_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #finalResultSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_T_L)
    ld      b, #5
    call    _GameConcatValue
    ret

    ; 結果の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 祝辞を送られる
;
FinalCongratulation:

    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 祝辞の表示
    ld      hl, #finalCongratulationString
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
    ld      hl, #FinalNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 祝辞の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進む
;
FinalNext:

    ; レジスタの保存
    
    ; 状態の更新
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 到着
;
finalArriveString:

    .db     ____, __LF
    .db     ___2, ___0, ___4, ___0, _KMA, _K_I, _KRU, _HNO, _HTA, _HHI, _KSN, _HWO, _HHE, _HTE, ____
    .db     _HTU, _H_I, _HNI, _K_O, _KRE, _KKO, _KSN, _K_N, _HNI, _HTA, _HTO, _KSN, _HRI, _HTU, _HKI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     _H_A, _HNA, _HTA, _HKO, _HSO, ____, _HSI, _H_N, _HNO, _HKA, _H_I, _HTA, _HKU, _HSI, _Hya, _HTE, _KSN, _HSU, _EXC
    .db     0x00

; 結果
;
finalResultYearString:

    .db     ____, __LF
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N
    .db     0x00

finalResultMonthJulyString:

    .db     ___7, _HKA, _KSN, _HTU
    .db     0x00

finalResultMonthAugustString:

    .db     ___8, _HKA, _KSN, _HTU
    .db     0x00

finalResultMonthSeptemberString:

    .db     ___9, _HKA, _KSN, _HTU
    .db     0x00

finalResultMonthOctoberString:

    .db     ___1, ___0, _HKA, _KSN, _HTU
    .db     0x00

finalResultMonthNovemberString:

    .db     ___1, ___1, _HKA, _KSN, _HTU
    .db     0x00

finalResultMonthDecemberString:

    .db     ___1, ___2, _HKA, _KSN, _HTU
    .db     0x00

finalResultDayString:

    .db     _HNI, _HTI, ____
    .db     0x00

finalResultWeekdayMondayString:

    .db     _HKE, _KSN, _HTU, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultWeekdayTuesdayString:

    .db     _HKA, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultWeekdayWednesdayString:

    .db     _HSU, _H_I, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultWeekdayThursdayString:

    .db     _HMO, _HKU, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultWeekdayFridayString:

    .db     _HKI, _H_N, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultWeekdaySaturdayString:

    .db     _HTO, _KSN, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultWeekdaySundayString:

    .db     _HNI, _HTI, _HYO, _H_U, _HHI, _KSN, __LF
    .db     0x00

finalResultItemString:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, ____, _HTA, _KSN, _H_N, _HYA, _HKU, ____, ____, _H_I, _HRU, _H_I, ____, ____, _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, ____, _HSI, _Hyo, _HSI, _KSN, _HKI, _H_N, __LF
    .db     0x00

finalResultSpaceString:

    .db     ____, 0x00

; 祝辞
;
finalCongratulationString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HNI, _K_A, _KME, _KRI, _KKA, _HTA, _KSN, _H_I, _HTO, _H_U, _HRI, _Hyo, _H_U, _KSI, _KSN, _K_e, _MNS, _KMU, _KSU, ____, ___K, _DOT, _KHO, _KPS, _MNS, _KKU, _HYO, _HRI, ____
    .db     _H_O, _H_I, _HWA, _H_I, _HNO, _HKO, _HTO, _HHA, _KSN, _HKA, _KSN, _HTO, _HTO, _KSN, _HKI, _HMA, _HSI, _HTA, _DOT, __LF
    .db     ____, __LF
    .db     _KLB, _H_A, _HNA, _HTA, _HNO, _H_A, _HTA, _HRA, _HSI, _H_I, _HSE, _H_I, _HKA, _HTU, _HKA, _KSN, _HYU, _HTA, _HKA, _HTE, _KSN, _H_A, _HRI, _HMA, _HSU, _HKO, _HTO, _HWO, __LF
    .db     ____, _HKO, _HKO, _HRO, _HKA, _HRA, _HNO, _HSO, _KSN, _HMI, _HMA, _HSU,  _KRB
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

