const jsonld = require('jsonld');

const doc = {
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Alice"
};

// Компактизация JSON-LD
jsonld.compact(doc, (err, compacted) => {
  console.log(JSON.stringify(compacted, null, 2));
});