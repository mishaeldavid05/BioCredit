;; BioCredit - Biodiversity conservation credits and ecosystem protection rewards platform
(define-data-var ecosystem-guardian principal tx-sender)
(define-data-var total-conservation-actions uint u0)
(define-data-var biodiversity-credit-rate uint u35) ;; credits per conservation action
(define-data-var last-credit-distribution uint u0)

(define-map conservationist-actions principal uint)
(define-map habitat-types principal (string-utf8 64))
(define-map approved-habitats (string-utf8 64) bool)

;; Error codes
(define-constant err-unauthorized-guardian (err u1600))
(define-constant err-guardian-already-appointed (err u1601))
(define-constant err-invalid-action-count (err u1602))
(define-constant err-no-credits-available (err u1603))
(define-constant err-no-conservation-actions (err u1604))
(define-constant err-invalid-habitat-type (err u1605))
(define-constant err-habitat-not-approved (err u1606))

;; Verify guardian authorization
(define-private (is-ecosystem-guardian (caller principal))
  (begin
    (asserts! (is-eq caller (var-get ecosystem-guardian)) err-unauthorized-guardian)
    (ok true)))

;; Initialize biodiversity conservation program
(define-public (establish-biodiversity-program (guardian principal))
  (begin
    (asserts! (is-none (map-get? conservationist-actions guardian)) err-guardian-already-appointed)
    (var-set ecosystem-guardian guardian)
    (ok "BioCredit biodiversity conservation program established")))

;; Approve habitat type for conservation tracking
(define-public (approve-habitat-type (habitat (string-utf8 64)))
  (begin
    (try! (is-ecosystem-guardian tx-sender))
    (asserts! (> (len habitat) u0) err-invalid-habitat-type)
    (map-set approved-habitats habitat true)
    (ok "Habitat type approved for conservation tracking")))

;; Record biodiversity conservation actions
(define-public (record-conservation-actions (action-count uint) (habitat-type (string-utf8 64)))
  (begin
    (asserts! (> action-count u0) err-invalid-action-count)
    (asserts! (default-to false (map-get? approved-habitats habitat-type)) err-habitat-not-approved)
    
    (let ((current-actions (default-to u0 (map-get? conservationist-actions tx-sender))))
      (map-set conservationist-actions tx-sender (+ current-actions action-count))
      (map-set habitat-types tx-sender habitat-type)
      (var-set total-conservation-actions (+ (var-get total-conservation-actions) action-count))
      (ok (+ current-actions action-count)))))

;; Distribute biodiversity credits
(define-public (distribute-biodiversity-credits)
  (begin
    (try! (is-ecosystem-guardian tx-sender))
    (let ((current-distribution (+ (var-get last-credit-distribution) u1))
          (total-actions (var-get total-conservation-actions)))
      (asserts! (> total-actions (var-get last-credit-distribution)) err-no-credits-available)
      
      (let ((credit-pool (* (var-get biodiversity-credit-rate) total-actions)))
        (var-set last-credit-distribution current-distribution)
        (ok credit-pool)))))

;; Claim biodiversity conservation rewards
(define-public (claim-biodiversity-rewards)
  (begin
    (let ((conservationist-action-count (default-to u0 (map-get? conservationist-actions tx-sender))))
      (asserts! (> conservationist-action-count u0) err-no-conservation-actions)
      
      (let ((total-actions (var-get total-conservation-actions))
            (base-credits (* (var-get biodiversity-credit-rate) conservationist-action-count))
            (action-proportion (/ (* conservationist-action-count u100000) total-actions)))
        
        (let ((final-credits (/ (* action-proportion base-credits) u100000)))
          (map-delete conservationist-actions tx-sender)
          (map-delete habitat-types tx-sender)
          (var-set total-conservation-actions (- (var-get total-conservation-actions) conservationist-action-count))
          (ok (+ conservationist-action-count final-credits)))))))

;; Read-only functions
(define-read-only (get-conservationist-actions (conservationist principal))
  (default-to u0 (map-get? conservationist-actions conservationist)))

(define-read-only (get-habitat-type (conservationist principal))
  (map-get? habitat-types conservationist))

(define-read-only (get-total-conservation-actions)
  (var-get total-conservation-actions))

(define-read-only (is-habitat-approved (habitat (string-utf8 64)))
  (default-to false (map-get? approved-habitats habitat)))