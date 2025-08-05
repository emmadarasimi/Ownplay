;; Ownplay In-Game Item NFT Contract
;; Clarity v1

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-ZERO-ADDRESS u101)
(define-constant ERR-ITEM-NOT-FOUND u102)
(define-constant ERR-NOT-OWNER u103)
(define-constant ERR-ITEM-LOCKED u104)
(define-constant ERR-PAUSED u105)

(define-constant ZERO-ADDR 'SP000000000000000000002Q6VF78)

;; Admin and paused state
(define-data-var admin principal tx-sender)
(define-data-var paused bool false)
(define-data-var last-token-id uint u0)

;; Maps
(define-map items uint
  {
    owner: principal,
    equipped: bool,
    locked: bool,
    metadata: (string-utf8 256)
  }
)

;; === Private Helpers ===

(define-private (is-admin)
  (is-eq tx-sender (var-get admin))
)

(define-private (ensure-not-paused)
  (asserts! (not (var-get paused)) (err ERR-PAUSED))
)

;; === Admin Functions ===

(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-eq new-admin ZERO-ADDR)) (err ERR-ZERO-ADDRESS))
    (var-set admin new-admin)
    (ok true)
  )
)

(define-public (set-paused (pause bool))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set paused pause)
    (ok pause)
  )
)

;; === Minting ===

(define-public (mint (recipient principal) (metadata (string-utf8 256)))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-eq recipient ZERO-ADDR)) (err ERR-ZERO-ADDRESS))
    (let ((next-id (+ u1 (var-get last-token-id))))
      (map-set items next-id {
        owner: recipient,
        equipped: false,
        locked: false,
        metadata: metadata
      })
      (var-set last-token-id next-id)
      (ok next-id)
    )
  )
)

;; === Transfers ===

(define-public (transfer (token-id uint) (to principal))
  (begin
    (ensure-not-paused)
    (match (map-get? items token-id)
      some-item
        (begin
          (asserts! (is-eq tx-sender (get owner some-item)) (err ERR-NOT-OWNER))
          (asserts! (not (get locked some-item)) (err ERR-ITEM-LOCKED))
          (asserts! (not (is-eq to ZERO-ADDR)) (err ERR-ZERO-ADDRESS))
          (map-set items token-id (merge some-item { owner: to }))
          (ok true)
        )
      (none (err ERR-ITEM-NOT-FOUND))
    )
  )
)

;; === Equip / Unequip ===

(define-public (equip (token-id uint))
  (begin
    (ensure-not-paused)
    (match (map-get? items token-id)
      some-item
        (begin
          (asserts! (is-eq tx-sender (get owner some-item)) (err ERR-NOT-OWNER))
          (map-set items token-id (merge some-item { equipped: true }))
          (ok true)
        )
      (none (err ERR-ITEM-NOT-FOUND))
    )
  )
)

(define-public (unequip (token-id uint))
  (begin
    (ensure-not-paused)
    (match (map-get? items token-id)
      some-item
        (begin
          (asserts! (is-eq tx-sender (get owner some-item)) (err ERR-NOT-OWNER))
          (map-set items token-id (merge some-item { equipped: false }))
          (ok true)
        )
      (none (err ERR-ITEM-NOT-FOUND))
    )
  )
)

;; === Lock / Unlock ===

(define-public (lock (token-id uint))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (match (map-get? items token-id)
      some-item
        (begin
          (map-set items token-id (merge some-item { locked: true }))
          (ok true)
        )
      (none (err ERR-ITEM-NOT-FOUND))
    )
  )
)

(define-public (unlock (token-id uint))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (match (map-get? items token-id)
      some-item
        (begin
          (map-set items token-id (merge some-item { locked: false }))
          (ok true)
        )
      (none (err ERR-ITEM-NOT-FOUND))
    )
  )
)

;; === Read-Only ===

(define-read-only (get-item (token-id uint))
  (match (map-get? items token-id)
    some-item (ok some-item)
    none (err ERR-ITEM-NOT-FOUND)
  )
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-read-only (is-paused)
  (ok (var-get paused))
)

(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)
