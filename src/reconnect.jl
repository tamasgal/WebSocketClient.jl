import Base: reset

export AbstractBackoff, Backoff, RandomizedBackoff, reset, backoff_min, backoff_max
export AbstractRetry, Retry, retry

abstract AbstractBackoff

type Backoff <: AbstractBackoff
    min::Float64
    max::Float64
    state::Int

    Backoff(min::Float64, max::Float64) = new(min, max, 0)
end

reset(b::Backoff) = b.state = 0
backoff_min(b::Backoff) = b.min
backoff_max(b::Backoff) = b.max

function call(b::Backoff)
    v = b.min + atan(b.state*b.state/32) * 2 / pi * (b.max - b.min)
    b.state += 1
    v
end

type RandomizedBackoff <: AbstractBackoff
    backoff::AbstractBackoff
    rng::AbstractRNG
    interval::Float64
end

reset(b::RandomizedBackoff) = reset(b.backoff)
backoff_min(b::RandomizedBackoff) = backoff_min(b.backoff)
backoff_max(b::RandomizedBackoff) = backoff_max(b.backoff)

function call(b::RandomizedBackoff)
    (r,) = (rand(b.rng, Float64, 1) - 0.5) * 2 * b.interval
    v = b.backoff()
    max(backoff_min(b), min(backoff_max(b), v + r))
end

abstract AbstractRetry

type Retry <: AbstractRetry
    backoff::AbstractBackoff
    fun::Function
    sleep_fun::Function

    Retry(backoff::AbstractBackoff, fun::Function;
          sleep_fun::Function=sleep) = new(backoff, fun, sleep_fun)
end

function retry(r::Retry)
    backoff_time = r.backoff()
    r.sleep_fun(backoff_time)
    r.fun()
end

reset(r::Retry) = reset(r.backoff)