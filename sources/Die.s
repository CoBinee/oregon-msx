; Die.s : 死亡
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

; 死亡する
;
_Die::
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 死亡の表示
    ld      hl, #dieString
    call    _GamePrint
    call    _GameFeed

    ; 背景の表示
    call    _BackClear

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

    ; 状態の更新
    ld      a, #APP_STATE_GAME_INITIALIZE
    ld      (_app + APP_STATE), a
;   jr      90$

    ; 初期化の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 医者にかかれずに死んだことを表示する
;
_DiePrintNoDoctor::

    ; レジスタの保存

    ; 死因の表示
    call    _GameClearString
    ld      a, (_value + VALUE_K8)
    or      a
    jr      nz, 10$
    ld      hl, #dieCauseString_0
    jr      11$
10$:
    ld      hl, #dieCauseString_1
11$:
    call    _GameConcatString
    ld      hl, #dieNoDoctorString
    call    _GameConcatString
    call    _GamePrint
    call    _GameFeed

    ; レジスタの復帰

    ; 終了
    ret

; 薬がなくなり死んだことを表示する
;
_DiePrintNoMedicine::

    ; レジスタの保存

    ; 死因の表示
    call    _GameClearString
    ld      a, (_value + VALUE_K8)
    or      a
    jr      nz, 10$
    ld      hl, #dieCauseString_0
    jr      11$
10$:
    ld      hl, #dieCauseString_1
11$:
    call    _GameConcatString
    ld      hl, #dieNoMedicineString
    call    _GameConcatString
    call    _GamePrint
    call    _GameFeed

    ; レジスタの復帰

    ; 終了
    ret

; 餓死したことを表示する
;
_DiePrintStarvation::

    ; レジスタの保存

    ; 死因の表示
    ld      hl, #dieStarvationString
    call    _GamePrint
    call    _GameFeed

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; 死亡
;
dieString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HHA, _K_O, _KRE, _KKO, _KSN, _K_N, _HNI, _HTA, _HTO, _KSN, _HRI, _HTU, _HKU, _HKO, _HTO, _HKA, _KSN, ____
    .db     _HTE, _KSN, _HKI, _HMA, _HSE, _H_N, _HTE, _KSN, _HSI, _HTA, _DOT, __LF
    .db     _HTU, _HKI, _KSN, _HHA, _HSE, _H_I, _HKO, _H_U, _HSU, _HRU, _HKO, _HTO, _HWO, ____
    .db     _HNE, _HKA, _KSN, _Htu, _HTE, _H_I, _HMA, _HSU, _DOT
    .db     0x00

; 死因
;
dieCauseString_0:

    .db     ____, __LF
    .db     _HHA, _H_I, _H_E, _H_N, _HNI, _HKA, _HKA, _HRI, _HMA, _HSI, _HTA, _HKA, _KSN, ____
    .db     0x00

dieCauseString_1:

    .db     ____, __LF
    .db     _HKE, _HKA, _KSN, _HWO, _HSI, _HMA, _HSI, _HTA, _HKA, _KSN, ____
    .db     0x00

; 医者にかかれず死亡
;
dieNoDoctorString:

    .db     _H_I, _HSI, _Hya, _HNI, _HKA, _HKA, _HRE, _HSU, _KSN, ____, _HSI, _HNI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 薬がなくなり死亡
;
dieNoMedicineString:

    .db     _HKU, _HSU, _HRI, _HKA, _KSN, _HTA, _HRI, _HSU, _KSN, ____, _HSI, _HNI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 食料が尽きて死亡
;
dieStarvationString:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HKA, _KSN, _HTU, _HKI, _HTE, ____, _HSI, _HNI, _HMA, _HSI, _HTA, _DOT
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

