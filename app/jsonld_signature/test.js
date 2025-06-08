import {vc} from '@digitalbazaar/vc';

const vcProof = await vc.issueCredential({
  credential: signedVC,
  suite: new Ed25519Signature2020({key: keyPair}),
  documentLoader
});