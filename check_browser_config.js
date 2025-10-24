// CHECK VISIONNAIRE BROWSER CONFIGURATION
//
// Buka browser di https://visionnaire-cda17.web.app/login
// Tekan F12 untuk Developer Console
// Copy-paste script ini ke Console tab:

console.log('='.repeat(70));
console.log('VISIONNAIRE CONFIGURATION CHECK');
console.log('='.repeat(70));
console.log('');

// Check all localStorage keys
console.log('1. ALL LOCALSTORAGE KEYS:');
console.log('-'.repeat(70));
for (let i = 0; i < localStorage.length; i++) {
    const key = localStorage.key(i);
    const value = localStorage.getItem(key);
    console.log(`  ${key}: ${value}`);
}
console.log('');

// Check common API URL keys
console.log('2. API URL CONFIGURATION:');
console.log('-'.repeat(70));
const apiKeys = [
    'API_URL',
    'MANAGEMENT_API',
    'DB_MANAGEMENT_API_URL',
    'BACKEND_URL',
    'BASE_URL',
    'apiUrl',
    'api_url'
];

apiKeys.forEach(key => {
    const value = localStorage.getItem(key);
    if (value) {
        console.log(`  ✓ ${key}: ${value}`);
    } else {
        console.log(`  ✗ ${key}: (not set)`);
    }
});

console.log('');
console.log('='.repeat(70));
console.log('EXPECTED API URL:');
console.log('  For localhost: http://127.0.0.1:8005');
console.log('  For ngrok: https://xxxxx.ngrok-free.app');
console.log('  For production: https://your-server.com');
console.log('='.repeat(70));
console.log('');
console.log('CREDENTIALS (after checking URL):');
console.log('  Username: user');
console.log('  Password: password');
console.log('='.repeat(70));
