 

self.importScripts("https://unpkg.com/sql.js@1.8.0/dist/sql-wasm.js");

let SQL;
let dbs = {};

const initSqlJs = self.initSqlJs;
const pending = initSqlJs({
  locateFile: (file) => `https://unpkg.com/sql.js@1.8.0/dist/${file}`,
}).then((sql) => {
  SQL = sql;
});

self.onmessage = async (e) => {
  const msg = e.data;
  await pending;

  switch (msg.action) {
    case "open": {
      const db = new SQL.Database();
      dbs[msg.dbId] = db;
      self.postMessage({ id: msg.id, result: true });
      break;
    }

    case "execute": {
      try {
        const db = dbs[msg.dbId];
        if (!db) throw new Error("Database not found");
        const result = db.exec(msg.sql);
        self.postMessage({ id: msg.id, result });
      } catch (err) {
        self.postMessage({ id: msg.id, error: err.message });
      }
      break;
    }

    case "close": {
      const db = dbs[msg.dbId];
      if (db) {
        db.close();
        delete dbs[msg.dbId];
      }
      self.postMessage({ id: msg.id, result: true });
      break;
    }

    default:
      self.postMessage({ id: msg.id, error: "Unknown action: " + msg.action });
  }
};
