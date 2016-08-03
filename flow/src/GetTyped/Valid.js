// @flow

export class Valid<V, A> {
    value: A;

    constructor(a: A) {
        this.value = a;
    }
}

function mkValid<V, A>(a: A): Valid<V, A> {
    return new Valid(a);
}

export type Success<A> = {tag: "success", value: A};
export type Failure<E> = {tag: "failure", errors: [E]};
export type Validation<E, A> = Success<A> | Failure<E>;

export function success<E, A>(a: A): Validation<E, A> {
    return {tag: "success", value: a};
}

export function failure<E, A>(errs: [E]): Validation<E, A> {
    return {tag: "failure", errors: errs};
}

export function validationErrors<E, A>(v: Validation<E, A>): [E] {
    return (v.tag === "failure"
            ? v.errors
            : []);
}

export function mapValidation<E, A, B>(f: (a: A) => B, v: Validation<E, A>)
: Validation<E, B> {
    return (v.tag === "failure"
            ? {tag: "failure", errors: v.errors}
            : {tag: "success", value: f(v.value)});
}

export function takeLeftValidation<E, A>(l: Validation<E, A>, r: Validation<E, A>)
: Validation<E, A> {
    return (l.tag === "failure" || r.tag === "failure"
            ? failure(validationErrors(l).concat(validationErrors(r)))
            : l);
}

export interface Validator<A> {
    validator(a: A): Validation<Error, A>;
}

export function validate<A, V: Validator<A>>(v: V, a: A)
: Validation<Error, Valid<V, A>> {
    return mapValidation(mkValid, v.validator(a));
}

class Integer {
    validator(x: number): Validation<Error, number> {
        return x % 1 === 0 ? success(x) : failure([new Error("floating")]);
    }
}

class Natural {
    validator(x: number): Validation<Error, number> {
        return takeLeftValidation(
            new Integer().validator(x),
            x > 0 ? success(x) : failure([new Error("<= 0")]));
    }
}

class Negative {
    validator(x: number): Validation<Error, number> {
        return (x > 0
                ? success(x)
                : failure([new Error("Not negative")]));
    }
}

function addNats(x: Valid<Natural, number>, y: Valid<Natural, number>): number {
    return x.value + y.value;
}
