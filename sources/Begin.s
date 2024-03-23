; Begin.s : 開始
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

; ターンを開始する
;
_Begin::
    
    ; レジスタの保存
    
    ; 食料の調整
    ld      hl, (_value + VALUE_F_L)
    bit     #0x07, h
    jr      z, 10$
    ld      hl, #0x0000
    ld      (_value + VALUE_F_L), hl
10$:

    ; 弾薬の調整
    ld      hl, (_value + VALUE_B_L)
    bit     #0x07, h
    jr      z, 11$
    ld      hl, #0x0000
    ld      (_value + VALUE_B_L), hl
11$:

    ; 衣類の調整
    ld      hl, (_value + VALUE_C_L)
    bit     #0x07, h
    jr      z, 12$
    ld      hl, #0x0000
    ld      (_value + VALUE_C_L), hl
12$:

    ; 必需品の調整
    ld      hl, (_value + VALUE_M1_L)
    bit     #0x07, h
    jr      z, 13$
    ld      hl, #0x0000
    ld      (_value + VALUE_M1_L), hl
13$:

    ; 牛の調整
    ld      hl, (_value + VALUE_A_L)
    bit     #0x07, h
    jr      z, 14$
    ld      hl, #0x0000
    ld      (_value + VALUE_A_L), hl
14$:

    ; 距離の保存
    ld      hl, (_value + VALUE_M_L)
    ld      (_value + VALUE_M2_L), hl

    ; 処理の更新
    ld      hl, #BeginCheckFood
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 食料を確認する
;
BeginCheckFood:

    ; レジスタの保存

    ; 0x00 : 所持品の調整
00$:
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 10$

    ; 食料の確認
    ld      hl, (_value + VALUE_F_L)
    bit     #0x07, h
    jr      nz, 01$
    ld      de, #13
    or      a
    sbc     hl, de
    jr      nc, 80$
01$:
    ld      hl, #beginFoodString
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x01 : ページ送り
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$
;   jr      80$

    ; 病気や怪我の確認
80$:
    ld      a, (_value + VALUE_S4)
    or      a
    jr      nz, 81$
    ld      a, (_value + VALUE_K8)
    or      a
    jr      nz, 81$
    ld      hl, #BeginShowStatus
    jr      89$
81$:
    ld      hl, #BeginSeeDoctor
;   jr      89$

    ; 処理の更新
89$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 開始の完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 医者にかかる
;
BeginSeeDoctor:
    
    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 医者にかかる
    ld      hl, (_value + VALUE_T_L)
    ld      de, #20
    or      a
    sbc     hl, de
    ld      (_value + VALUE_T_L), hl
    jr      c, 00$
    ld      hl, #beginDoctorString
    call    _GamePrint
    call    _GameFeed
    jr      01$
00$:
    call    _DiePrintNoDoctor
01$:

    ; 条件のクリア
    xor     a
    ld      (_value + VALUE_S4), a
    ld      (_value + VALUE_K8), a

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

    ; 医者にかかれなかった
    ld      a, (_value + VALUE_T_H)
    bit     #0x07, a
    jr      z, 11$
    ld      hl, #0x0000
    ld      (_value + VALUE_T_L), hl
    ld      hl, #_Die
    jr      19$

    ; 医者にかかった
11$:
    ld      hl, #BeginShowStatus
;   jr      19$

    ; 処理の更新
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 医者の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 状況を表示する
;
BeginShowStatus:
    
    ; レジスタの保存

    ; 0x00 : 走破距離の表示
00$:
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 10$

    ; 走破距離の表示
    call    _GameClearString
    ld      a, (_value + VALUE_M9)
    or      a
    jr      nz, 01$
    ld      hl, (_value + VALUE_M_L)
    jr      02$
01$:
    xor     a
    ld      (_value + VALUE_M9), a
    ld      hl, #950
02$:
    ld      b, #0x00
    call    _GameConcatValue
    ld      hl, #beginStatusMileageString
    call    _GameConcatString
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jp      90$

    ; 0x01 : 所持品の表示
10$:
    dec     a
    jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 所持品の表示
    call    _GameClearString
    ld      hl, #beginStatusItemString
    call    _GameConcatString
    ld      hl, #beginStatusSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_F_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #beginStatusSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_B_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #beginStatusSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_C_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #beginStatusSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_M1_L)
    ld      b, #5
    call    _GameConcatValue
    ld      hl, #beginStatusSpaceString
    call    _GameConcatString
    ld      hl, (_value + VALUE_T_L)
    ld      b, #5
    call    _GameConcatValue
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

    ; 背景の表示
    call    _BackClear

    ; 処理の更新
    ld      a, (_value + VALUE_X1)
    bit     #0x07, a
    jr      nz, 21$
    ld      hl, #BeginStopFort
    jr      22$
21$:
    ld      hl, #BeginHunt
22$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 状況の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 交易所に着く
;
BeginStopFort:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #beginFortQueryString
    call    _GamePrint

    ; 選択の設定
    ld      hl, #beginFortSelect
    ld      a, #0x03
    call    _GameSelect

    ; 背景の表示
    call    _BackFort

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; 選択の取得
    call    _GameGetSelectItem
    jr      nc, 90$
    inc     a
    ld      (_value + VALUE_X), a
    cp      #0x02
    jr      nz, 80$

    ; 弾薬が足りない
    ld      hl, (_value + VALUE_B_L)
    bit     #0x07, h
    jr      nz, 11$
    ld      de, #40
    or      a
    sbc     hl, de
    jr      nc, 80$
11$:
    ld      hl, #beginHuntNoBulletString
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
    jr      90$

    ; 処理の更新
80$:
    ld      hl, #BeginNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 交易所の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 狩りに出る
;
BeginHunt:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    ld      hl, #beginHuntQueryString
    call    _GamePrint

    ; 選択の設定
    ld      hl, #beginHuntSelect
    ld      a, #0x02
    call    _GameSelect

    ; 背景の表示
    call    _BackYard

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 選択
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; 選択の取得
    call    _GameGetSelectItem
    jr      nc, 90$
    inc     a
    inc     a
    ld      (_value + VALUE_X), a
    cp      #0x03
    jr      z, 80$

    ; 弾薬が足りない
    ld      hl, (_value + VALUE_B_L)
    bit     #0x07, h
    jr      nz, 11$
    ld      de, #40
    or      a
    sbc     hl, de
    jr      nc, 80$
11$:
    ld      hl, #beginHuntNoBulletString
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
    jr      90$

    ; 処理の更新
80$:
    ld      hl, #BeginNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; 狩りの完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 次に進む
;
BeginNext:

    ; レジスタの保存

    ; 交易所の更新
    ld      hl, #(_value + VALUE_X1)
    ld      a, (hl)
    neg
    ld      (hl), a

    ; 処理の更新
    ld      a, (_value + VALUE_X)
    dec     a
    jr      nz, 10$
    ld      hl, #_Fort
    jr      19$
10$:
    dec     a
    jr      nz, 11$
    ld      hl, #_Hunt
    jr      19$
11$:
    ld      hl, #_Eat
;   jr      19$
19$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 定数の定義
;

; ターンの開始
;
beginFoodString:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, _HWO, _HKA, _H_U, _HKA, ____, _HKA, _HRI, _HWO, _HSI, _HMA, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

; 医者
;
beginDoctorString:

    .db     _H_I, _HSI, _Hya, _HNI, _HKA, _HKA, _HRI, ____, _DOL, ___2, ___0, _HWO, _HHA, _HRA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 状況
;
beginStatusLfString:

    .db     ____, __LF, 0x00

beginStatusSpaceString:

    .db     ____, 0x00

beginStatusMileageString:

    .db     _KMA, _K_I, _KRU, _HWO, ____, _HTA, _HHI, _KSN, _HSI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

beginStatusItemString:

    .db     _HSI, _Hyo, _HKU, _HRI, _Hyo, _H_U, ____, _HTA, _KSN, _H_N, _HYA, _HKU, ____, ____, _H_I, _HRU, _H_I, ____, ____, _HHI, _HTU, _HSI, _KSN, _Hyu, _HHI, _H_N, ____, _HSI, _Hyo, _HSI, _KSN, _HKI, _H_N, __LF
    .db     0x00

; 交易所
;
beginFortQueryString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HHA, ____, _HTO, _KSN, _H_U, _HSI, _HMA, _HSU, _HKA, _QUE, __LF
    .db     _LRB, ___1, _RRB, _HKO, _H_U, _H_E, _HKI, _HSI, _KSN, _Hyo, _HNI, _HYO, _HRU, __LF
    .db     _LRB, ___2, _RRB, _HKA, _HRI, _HWO, _HSU, _HRU, __LF
    .db     _LRB, ___3, _RRB, _HTA, _HHI, _KSN, _HWO, _HTU, _HTU, _KSN, _HKE, _HRU
    .db     0x00

beginFortSelect:

    .dw     beginFortSelectString_0
    .dw     beginFortSelectString_1
    .dw     beginFortSelectString_2

beginFortSelectString_0:

    .db     _HKO, _H_U, _H_E, _HKI, _HSI, _KSN, _Hyo, _HNI, _HYO, _HRU, 0x00

beginFortSelectString_1:

    .db     _HKA, _HRI, _HWO, _HSU, _HRU, 0x00

beginFortSelectString_2:

    .db     _HTA, _HHI, _KSN, _HWO, _HTU, _HTU, _KSN, _HKE, _HRU, 0x00

; 狩り
;
beginHuntQueryString:

    .db     ____, __LF
    .db     _H_A, _HNA, _HTA, _HHA, ____, _HTO, _KSN, _H_U, _HSI, _HMA, _HSU, _HKA, _QUE, __LF
    .db     _LRB, ___1, _RRB, _HKA, _HRI, _HWO, _HSU, _HRU, __LF
    .db     _LRB, ___2, _RRB, _HTA, _HHI, _KSN, _HWO, _HTU, _HTU, _KSN, _HKE, _HRU
    .db     0x00

beginHuntSelect:

    .dw     beginHuntSelectString_0
    .dw     beginHuntSelectString_1

beginHuntSelectString_0:

    .db     _HKA, _HRI, _HWO, _HSU, _HRU, 0x00

beginHuntSelectString_1:

    .db     _HTA, _HHI, _KSN, _HWO, _HTU, _HTU, _KSN, _HKE, _HRU, 0x00

beginHuntNoBulletString:

    .db     _HKA, _HRI, _HWO, _HSU, _HRU, _HNI, _HHA, _HMO, _Htu, _HTO, _HTA, _KSN, _H_N, _HYA, _HKU, _HKA, _KSN, ____, _HHI, _HTU, _HYO, _H_U, _HTE, _KSN, _HSU, _DOT
    .db     0x00


; DATA 領域
;
    .area   _DATA

; 変数の定義
;

