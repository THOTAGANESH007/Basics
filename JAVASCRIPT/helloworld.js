// console.log("Hello World!!!")
// // window.alert("Bhaai")
// // var x;
// // x=9;
// // let y = 6;
// // let z = x + y;
// //     console.log(x)

// // {
// //     var x=8
// //     console.log(x)
// // }
// // console.log(x)

// let k=7;
// let y=9;
// console.log(y);

// // const z=oi;
// // z=jkfn;

// // sayHi();

// // let sayHi = function () {
// //     console.log("Hi");
// // };

// // var k = 1;

// // function test() {
// //     console.log(k);
// //     // let k = 2;
// // }

// // test();

// var x = 10;

// // function foo() {
// //     console.log(x);
// // }

// function bar() {
//     var x = 20;
//     // foo();
//     function foo() {
//     console.log(x);
// }
// foo()
// }

// bar();

// var i=8
// console.log(i)
// for (let l=0;l<7;l++) {
//     const i=9
//     console.log(i)
// }
// console.log(i)


// // function test(){
// //     var p = 20;
// //     console.log(p)
// // }
// {
//     let p=33
// }
//     console.log(p)



function outer() {
    let x = 10;
    var y = 20;

    function inner() {
        console.log(x + y);
    }

    return inner;
}

// outer()
bhaai = outer();
bhaai()

const x = Symbol();
const y = Symbol();

console.log(x)
console.log(y)