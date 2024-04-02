importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCtodL7DA8dz3B5HEMuJ7di0DY2MEQOjws",
  authDomain: "flutter-end-to-end.firebaseapp.com",
  projectId: "flutter-end-to-end",
  storageBucket: "flutter-end-to-end.appspot.com",
  messagingSenderId: "334267766183",
  appId: "1:334267766183:web:a26cc63b3cc29fe3a35282",
  measurementId: "G-NJEW95MV5Z"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
