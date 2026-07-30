const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} = require('@firebase/rules-unit-testing');
const { doc, getDoc, setDoc } = require('firebase/firestore');

describe('AmiN Firestore ownership rules', () => {
  let environment;

  before(async () => {
    environment = await initializeTestEnvironment({
      projectId: 'amin-rules-test',
      firestore: {
        host: '127.0.0.1',
        port: 8080,
        rules: fs.readFileSync(path.join(__dirname, '..', 'firestore.rules'), 'utf8'),
      },
    });
  });

  after(async () => environment.cleanup());
  beforeEach(async () => environment.clearFirestore());

  it('allows a student to write and read only their own subtree', async () => {
    const alice = environment.authenticatedContext('alice').firestore();
    const bob = environment.authenticatedContext('bob').firestore();
    const aliceSummary = doc(alice, 'students/alice/summary/current');

    await assertSucceeds(setDoc(aliceSummary, { lessonsCompleted: 2 }));
    await assertSucceeds(getDoc(aliceSummary));
    await assertFails(getDoc(doc(bob, 'students/alice/summary/current')));
  });

  it('denies unauthenticated student access and public collections', async () => {
    const anonymous = environment.unauthenticatedContext().firestore();

    await assertFails(getDoc(doc(anonymous, 'students/alice')));
    await assertFails(setDoc(doc(anonymous, 'public/student'), { uid: 'alice' }));
    assert.ok(true);
  });
});
