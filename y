rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
   match /public/{publicDoc}{
   allow read: if true;
   }
   match /{document=**} {
      allow read, write: if request.auth.uid != null;
    }
  }
}