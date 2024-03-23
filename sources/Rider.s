; Rider.s : ライダー
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

; ライダーと遭遇する
;
_Rider::
    
    ; レジスタの保存
    
    ; 遭遇
    ld      hl, (_value + VALUE_M_L)
    bit     #0x07, h
    jr      nz, 10$
    ld      a, #100
    call    _GameDiv
    ld      de, #4
    or      a
    sbc     hl, de
    jr      c, 10$
    ld      c, l
    ld      b, h
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, de
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, de
    ld      de, #72
    add     hl, de
    ex      de, hl
    ld      l, c
    ld      h, b
    add     hl, hl
    ld      bc, #12
    add     hl, bc
    ld      a, l
    ex      de, hl
    call    _GameDiv
;   dec     hl
    ld      e, l
;   inc     e
    call    _SystemGetRandom
    ld      l, a
    ld      h, #0x00
    ld      a, #10
    call    _GameDiv
    cp      e
    jr      c, 10$
    ld      hl, #RiderAhead
    jr      11$
10$:
    ld      hl, #RiderNext
;   jr      11$
11$:
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; ライダーを発見する
;
RiderAhead:
    
    ; レジスタの保存
    
    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 確認の表示
    call    _GameClearString
    ld      hl, #riderAheadQueryString_0
    call    _GameConcatString
    call    _SystemGetRandom
    cp      #(256 * 8 / 10)
    jr      c, 00$
    ld      hl, #riderAheadQueryString_1
    ld      a, #0x01
    jr      01$
00$:
    ld      hl, #riderAheadQueryString_2
    xor     a
01$:
    ld      (_value + VALUE_S5), a
    call    _GameConcatString
    ld      hl, #riderAheadQueryString_3
    call    _GameConcatString
    call    _GamePrint

    ; 敵対的かどうかの反転
    call    _SystemGetRandom
    cp      #(256 * (2 + 1) / 10)
    jr      nc, 02$
    ld      hl, #(_value + VALUE_S5)
    ld      a, #1
    sub     (hl)
    ld      (hl), a
02$:

    ; 選択の設定
    ld      hl, #riderAheadSelect
    ld      a, #0x04
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
    ld      (_value + VALUE_T1), a

    ; 処理の更新
    ld      a, (_value + VALUE_S5)
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      a, (_value + VALUE_T1)
    dec     a
    add     a, a
    add     a, e
    ld      e, a
    ld      d, #0x00
    ld      hl, #riderProc
    add     hl, de
    ld      e, (hl)
    inc     hl
    ld      d, (hl)
    ld      (_game + GAME_PROC_L), de
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; ライダーの完了
90$:
    
    ; レジスタの復帰
    
    ; 終了
    ret

; 敵対的なライダーから逃げる
;
RiderHostileRun:

    ; レジスタの保存

    ; マイルを進める
    ld      hl, (_value + VALUE_M_L)
    ld      de, #20
    add     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 必需品の消耗
    ld      hl, (_value + VALUE_M1_L)
    ld      de, #15
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M1_L), hl

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B_L)
    ld      de, #150
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 牛の消耗
    ld      hl, (_value + VALUE_A_L)
    ld      de, #40
    or      a
    sbc     hl, de
    ld      (_value + VALUE_A_L), hl

    ; 処理の更新
    ld      hl, #RiderHostileResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 敵対的なライダーに攻撃する
;
RiderHostileAttack:

; 敵対的なライダーに対し幌馬車を囲む
;
RiderHostileCircle:

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
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; 射撃の監視
    call    _GameIsBang
    jr      nc, 90$

    ; 結果の表示
    ld      hl, (_value + VALUE_B1_L)
    ld      de, #(0x0001 + 0x0001)
    or      a
    sbc     hl, de
    jr      nc, 11$
    ld      hl, #riderHostileAttackBestString
    jr      13$
11$:
    add     hl, de
    ld      de, #(0x0004 + 0x0001)
    or      a
    sbc     hl, de
    jr      nc, 12$
    ld      hl, #riderHostileAttackGoodString
    jr      13$
12$:
    ld      a, #0x01
    ld      (_value + VALUE_K8), a
    ld      hl, #riderHostileAttackPoorString
;   jr      13$
13$:
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 結果
20$:
;   dec     a
;   jr      nz, 30$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B1_L)
    ld      a, (_value + VALUE_T1)
    cp      #0x02
    jr      nz, 21$
    add     hl, hl
    add     hl, hl
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    add     hl, de
    jr      22$
21$:
    add     hl, hl
    ld      e, l
    ld      d, h
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, hl
    or      a
    sbc     hl, de
;   jr      22$
22$:
    ld      de, #80
    add     hl, de
    ex      de, hl
    ld      hl, (_value + VALUE_B_L)
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 処理の更新
    ld      hl, #RiderHostileResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 攻撃の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 敵対的なライダーに対しそのまま進む
;
RiderHostileContinue:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 被害を受ける
    call    _SystemGetRandom
    cp      #(256 * (8 + 1) / 10)
    jr      nc, 01$

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B_L)
    ld      de, #150
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #15
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #RiderHostileResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$

    ; 何もしてこない
01$:
    ld      hl, #riderHostileContinueString
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
    ld      hl, #RiderNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 通過の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 敵対的なライダーとの結末
;
RiderHostileResult:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 結末の表示
    ld      hl, #riderHostileResultCheckString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 結末
10$:
    ld      a, (_game + GAME_STATE)
    dec     a
    jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 弾薬の確認
    ld      a, (_value + VALUE_B_H)
    bit     #0x07, a
    jr      z, 80$

    ; 死亡の表示
    ld      hl, #riderHostileResultDieString
    call    _GamePrint
    call    _GameFeed

    ; 状態の更新
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
    jr      90$

    ; 0x02 : 死亡
20$:
;   dec     a
;   jr      nz, 30$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

   ; 処理の更新
    ld      hl, #_Die
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
    jr      90$
 
    ; 処理の更新
80$:
    ld      hl, #RiderNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 結末の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 友好的なライダーから逃げる
;
RiderFriendlyRun:

    ; レジスタの保存

    ; 牛の消耗
    ld      hl, (_value + VALUE_A_L)
    ld      de, #10
    or      a
    sbc     hl, de
    ld      (_value + VALUE_A_L), hl

    ; 処理の更新
    ld      hl, #RiderFriendlyResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 友好的なライダーに攻撃する
;
RiderFriendlyAttack:

    ; レジスタの保存

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #5
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 弾薬の消費
    ld      hl, (_value + VALUE_B_L)
    ld      de, #100
    or      a
    sbc     hl, de
    ld      (_value + VALUE_B_L), hl

    ; 処理の更新
    ld      hl, #RiderFriendlyResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 友好的なライダーに対しそのまま進む
;
RiderFriendlyContinue:

    ; レジスタの保存

    ; 処理の更新
    ld      hl, #RiderFriendlyResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 友好的なライダーに対し幌馬車を囲む
;
RiderFriendlyCircle:

    ; レジスタの保存

    ; 進行の停滞
    ld      hl, (_value + VALUE_M_L)
    ld      de, #20
    or      a
    sbc     hl, de
    ld      (_value + VALUE_M_L), hl

    ; 処理の更新
    ld      hl, #RiderFriendlyResult
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰

    ; 終了
    ret

; 友好的なライダーとの結末
;
RiderFriendlyResult:

    ; レジスタの保存

    ; 初期化
    ld      a, (_game + GAME_STATE)
    or      a
    jr      nz, 09$

    ; 結末の表示
    ld      hl, #riderFriendlyResultString
    call    _GamePrint
    call    _GameFeed

    ; 初期化の完了
    ld      hl, #(_game + GAME_STATE)
    inc     (hl)
09$:

    ; 0x01 : 結末
10$:
;   ld      a, (_game + GAME_STATE)
;   dec     a
;   jr      nz, 20$

    ; ページ送りの監視
    call    _GameIsFeed
    jr      nc, 90$

    ; 処理の更新
    ld      hl, #RiderNext
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a
;   jr      90$

    ; 結末の完了
90$:

    ; レジスタの復帰

    ; 終了
    ret

; 次へ進む
;
RiderNext:
    
    ; レジスタの保存
    
    ; 処理の更新
    ld      hl, #_Event
    ld      (_game + GAME_PROC_L), hl
    xor     a
    ld      (_game + GAME_STATE), a

    ; レジスタの復帰
    
    ; 終了
    ret

; 定数の定義
;

; 発見
;
riderAheadQueryString_0:

    .db     ____, __LF
    .db     _HYU, _HKU, _HTE, _HNI, ____, _H_U, _HMA, _HNI, _HNO, _Htu, _HTA, _HMO, _HNO, _HTA, _HTI, _HKA, _KSN, _H_I, _HMA, _HSU, _DOT, __LF
    .db     0x00

riderAheadQueryString_1:

    .db     _HKA, _HRE, _HRA, _HHA, _HYU, _H_U, _HKO, _H_U, _HTE, _HKI, _HNA, _HYO, _H_U, _HNI, ____, _HMI, _H_E, _HMA, _HSU, _DOT, __LF
    .db     0x00

riderAheadQueryString_2:

    .db     _HKA, _HRE, _HRA, _HHA, _HTE, _HKI, _H_I, _HWO, _HMO, _Htu, _HTE, _H_I, _HRU, _HYO, _H_U, _HNI, ____, _HMI, _H_E, _HMA, _HSU, _DOT, __LF
    .db     0x00

riderAheadQueryString_3:

    .db     _H_A, _HNA, _HTA, _HHA, ____, _HTO, _KSN, _H_U, _HSI, _HMA, _HSU, _HKA, _QUE
    .db     0x00

riderAheadSelect:

    .dw     riderAheadSelectString_0
    .dw     riderAheadSelectString_1
    .dw     riderAheadSelectString_2
    .dw     riderAheadSelectString_3

riderAheadSelectString_0:

    .db     _HNI, _HKE, _KSN, _HRU, 0x00

riderAheadSelectString_1:

    .db     _HKO, _H_U, _HKE, _KSN, _HKI, _HWO, _HSI, _HKA, _HKE, _HRU, 0x00

riderAheadSelectString_2:

    .db     _HSO, _HNO, _HMA, _HMA, _HSU, _HSU, _HMU, 0x00

riderAheadSelectString_3:

    .db     _HHO, _HRO, _HHA, _KSN, _HSI, _Hya, _HWO, _HKA, _HKO, _H_U, 0x00

; ライダーへの対応
;
riderProc:

    .dw     RiderHostileRun
    .dw     RiderHostileAttack
    .dw     RiderHostileContinue
    .dw     RiderHostileCircle
    .dw     RiderFriendlyRun
    .dw     RiderFriendlyAttack
    .dw     RiderFriendlyContinue
    .dw     RiderFriendlyCircle

; 敵対的
;
riderHostileAttackBestString:

    .db     _KNA, _K_I, _KSU, _KSI, _Kyo, _Ktu, _KTO, _DOT
    .db     _HKA, _HRE, _HRA, _HWO, _H_O, _H_I, _HHA, _HRA, _H_U, _HKO, _HTO, _HKA, _KSN, _HTE, _KSN, _HKI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

riderHostileAttackGoodString:

    .db     _KKO, _KRU, _KTO, ___4, ___5, _HTE, _KSN, ____, _HNA, _H_N, _HTO, _HKA, _H_O, _H_I, _HHA, _HRA, _H_U, _HKO, _HTO, _HKA, _KSN, _HTE, _KSN, _HKI, _HMA, _HSI, _HTA, _DOT
    .db     0x00

riderHostileAttackPoorString:

    .db     _KNA, _K_I, _KHU, _HTE, _KSN, _HSA, _HSA, _HRE, _HTE, _HSI, _HMA, _H_I, _HMA, _HSI, _HTA, _DOT
    .db     _HHA, _HYA, _HKU, _H_I, _HSI, _Hya, _HNI, _HMI, _HSE, _HNA, _HKE, _HRE, _HHA, _KSN, _HNA, _HRI, _HMA, _HSE, _H_N, _DOT
    .db     0x00

riderHostileContinueString:

    .db     _HKA, _HRE, _HRA, _HHA, _HNA, _HNI, _HMO, _HSI, _HTE, _HKI, _HMA, _HSE, _H_N, _HTE, _KSN, _HSI, _HTA, _DOT
    .db     0x00

riderHostileResultCheckString:

    .db     _HKA, _HRE, _HRA, _HNI, _HYO, _Htu, _HTE, _HHI, _HKA, _KSN, _H_I, _HKA, _KSN, _HNA, _HKA, _Htu, _HTA, _HKA, _HTO, _KSN, _H_U, _HKA, _HWO, ____, _HKA, _HKU, _HNI, _H_N, _HSI, _HMA, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

riderHostileResultDieString:

    .db     _HTA, _KSN, _H_N, _HYA, _HKU, _HWO, _H_U, _HTI, _HTU, _HKU, _HSI, _HTE, _HSI, _HMA, _H_I, ____, _HKA, _HRE, _HRA, _HNI, _HKO, _HRO, _HSA, _HRE, _HMA, _HSI, _HTA, _DOT
    .db     0x00

; 友好的
;
riderFriendlyResultString:

    .db     _HKA, _HRE, _HRA, _HHA, _HYU, _H_U, _HKO, _H_U, _HTE, _HKI, _HTE, _KSN, _HSI, _HTA, _HKA, _KSN, ____
    .db     _HNE, _H_N, _HNO, _HTA, _HME, _HHI, _HKA, _KSN, _H_I, _HKA, _KSN, _HNA, _HKA, _Htu, _HTA, _HKA, _HTO, _KSN, _H_U, _HKA, _HWO, ____, _HKA, _HKU, _HNI, _H_N, _HSI, _HMA, _HSI, _Hyo, _H_U, _DOT
    .db     0x00

; DATA 領域
;
    .area   _DATA

; 変数の定義
;

