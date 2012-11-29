module.exports = 
    
  development:
    sendEmails: false
    savePics:   false
    
    database:
      host: "192.168.1.1"
      db:   "myproject-dev"
      
  production:
    sendEmails: true
    
    database:
      db: "myproject-production"
    