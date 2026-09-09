//! A small, seedable pseudo-random generator.
//!
//! MML has `Random(a,b)` and the "曖昧さ" humanising options, so the compiler
//! needs randomness — but not `getrandom`, which needs extra plumbing under
//! WASM. A seeded xorshift keeps the core dependency-free and makes compiles
//! reproducible, so a golden test of a random-using song is possible at all.

/// xorshift64*, seeded to a fixed default so runs repeat.
#[derive(Debug, Clone)]
pub struct Rng {
    state: u64,
}

impl Default for Rng {
    fn default() -> Self {
        Self::with_seed(0)
    }
}

impl Rng {
    pub fn with_seed(seed: i64) -> Self {
        // Any non-zero state will do; xorshift is stuck at zero.
        Self {
            state: (seed as u64) ^ 0x9e37_79b9_7f4a_7c15,
        }
    }

    pub fn reseed(&mut self, seed: i64) {
        *self = Self::with_seed(seed);
    }

    fn next_u64(&mut self) -> u64 {
        let mut x = self.state;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.state = x;
        x.wrapping_mul(0x2545_f491_4f6c_dd1d)
    }

    /// A value in `low..=high`, inclusive. Order of the bounds does not matter.
    pub fn range(&mut self, low: i64, high: i64) -> i64 {
        let (low, high) = if low <= high {
            (low, high)
        } else {
            (high, low)
        };
        let span = (high - low).unsigned_abs().saturating_add(1);
        if span == 0 {
            return low;
        }
        low + (self.next_u64() % span) as i64
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn stays_within_range() {
        let mut rng = Rng::default();
        for _ in 0..1000 {
            let value = rng.range(10, 20);
            assert!((10..=20).contains(&value), "out of range: {value}");
        }
    }

    #[test]
    fn a_single_value_range_is_that_value() {
        let mut rng = Rng::default();
        assert_eq!(rng.range(5, 5), 5);
    }

    #[test]
    fn reversed_bounds_still_work() {
        let mut rng = Rng::default();
        for _ in 0..100 {
            let value = rng.range(20, 10);
            assert!((10..=20).contains(&value));
        }
    }

    #[test]
    fn the_same_seed_gives_the_same_sequence() {
        let mut a = Rng::with_seed(42);
        let mut b = Rng::with_seed(42);
        let from_a: Vec<i64> = (0..10).map(|_| a.range(0, 1000)).collect();
        let from_b: Vec<i64> = (0..10).map(|_| b.range(0, 1000)).collect();
        assert_eq!(from_a, from_b);
    }

    #[test]
    fn different_seeds_diverge() {
        let mut a = Rng::with_seed(1);
        let mut b = Rng::with_seed(2);
        let from_a: Vec<i64> = (0..10).map(|_| a.range(0, 1_000_000)).collect();
        let from_b: Vec<i64> = (0..10).map(|_| b.range(0, 1_000_000)).collect();
        assert_ne!(from_a, from_b);
    }
}
