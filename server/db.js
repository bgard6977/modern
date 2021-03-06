const connect = require('knex');
const vcap = process.env.VCAP_SERVICES ? JSON.parse(process.env.VCAP_SERVICES) : undefined;
const config = {
    client: 'oracledb',
    connection: {
        user: vcap ? vcap.oracle.credentials.user : "modern_test",
        password: vcap ? vcap.oracle.credentials.password : "password",
        connectString : vcap ? vcap.oracle.credentials.name : "127.0.0.1:1521/ORCLCDB.localdomain"
    }
};
console.log(`connecting to`, config);
const pool = connect(config);
module.exports = pool;