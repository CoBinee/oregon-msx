; Date.s : 日付
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

; 日付が変わる
;
_Date::

    ; レジスタの保存

    ; 背景の表示
    call    _BackClear

    ; 処理の更新
    ld      hl, (_value + VALUE_M_L)
    ld      de, #2040
    or      a
    sbc     hl, de
    jr      nc, 10$
    ld      hl, #DatePast2Weeks
    jr      19$
10$:
    ld      hl, #_Final
;   jr      19$
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; ２週間経過させる
;
DatePast2Weeks:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 日付の更新
    ld      hl, #(_value + VALUE_D3)
    inc     (hl)
    ld      a, (hl)
    cp      #20
    jr      nc, 00$

    ; 日付の表示
    call    _GameClearString
    ld      hl, #dateLfString
    call    _GameConcatString
    ld      a, (_value + VALUE_D3)
    ld      d, #0x00
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    add     a, a
    rl      d
    ld      e, a
    ld      d, #0x00
    ld      hl, #dateDayString
    add     hl, de
    call    _GameConcatString
    ld      hl, #dateMondayString
    call    _GameConcatString
    call    _GamePrint
    jr      01$

    ; 期限切れ    
00$:
    ld      hl, #dateOverString
    call    _GamePrint

    ; ページ送り
01$:
    call    _GameFeed

    ; 背景の表示
    call    _BackTrail

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
    ld      hl, #DateNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 経過の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 次へ進める
;
DateNext:

    ; レジスタの保存

    ; 日付の確認
    ld      a, (_value + VALUE_D3)
    cp      #20
    jr      nc, 10$
    ld      hl, #_Begin
    jr      19$
10$:
    ld      hl, #_Die
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 日付
;
dateLfString:

    .db     ____, __LF, 0x00

dateDayString:

    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___3, _HKA, _KSN, _HTU, ___2, ___9, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___4, _HKA, _KSN, _HTU, ___1, ___2, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___4, _HKA, _KSN, _HTU, ___2, ___6, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___5, _HKA, _KSN, _HTU, ___1, ___0, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___5, _HKA, _KSN, _HTU, ___2, ___4, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___6, _HKA, _KSN, _HTU, ___7, _HNI, _HTI, 0x00, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___6, _HKA, _KSN, _HTU, ___2, ___1, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___7, _HKA, _KSN, _HTU, ___5, _HNI, _HTI, 0x00, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___7, _HKA, _KSN, _HTU, ___1, ___9, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___8, _HKA, _KSN, _HTU, ___2, _HNI, _HTI, 0x00, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___8, _HKA, _KSN, _HTU, ___1, ___6, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___8, _HKA, _KSN, _HTU, ___3, ___0, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___9, _HKA, _KSN, _HTU, ___1, ___3, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___9, _HKA, _KSN, _HTU, ___2, ___7, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___1, ___0, _HKA, _KSN, _HTU, ___1, ___1, _HNI, _HTI, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___1, ___0, _HKA, _KSN, _HTU, ___2, ___5, _HNI, _HTI, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___1, ___1, _HKA, _KSN, _HTU, ___8, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___1, ___1, _HKA, _KSN, _HTU, ___2, ___2, _HNI, _HTI, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___1, ___2, _HKA, _KSN, _HTU, ___6, _HNI, _HTI, 0x00, 0x00
    .db     ___1, ___8, ___4, ___7, _HNE, _H_N, ___1, ___2, _HKA, _KSN, _HTU, ___2, ___0, _HNI, _HTI, 0x00

dateMondayString:

    .db     ____, _HKE, _KSN, _HTU, _HYO, _H_U, _HHI, _KSN, 0x00

dateOverString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HNO, _HTA, _HHI, _KSN, _HHA, ____, _HNA, _HKA, _KSN, _HKU, _HKA, _HKA, _HRI, _HSU, _HKI, _KSN, _HTA, _DOT
    .db     _HHU, _HYU, _HNO, _H_A, _HRA, _HSI, _HNI, _HYO, _Htu, _HTE, ____, _H_A, _HNA, _HTA, _HNO, _HKA, _HSO, _KSN, _HKU, _HHA, _HSI, _HNI, _HTA, _H_E, _HTA, _DOT
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

