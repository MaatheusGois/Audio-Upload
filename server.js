const express = require('express')
var multer = require('multer');

const app = express()

app.use(express.static('public'))


//ROUTES

//Multer
var Storage = multer.diskStorage({
    destination: function(req, file, callback) {
        callback(null, "./");
    },
    filename: function(req, file, callback) {
        callback(null, file.originalname);
    }
});
  
var upload = multer({
    storage: Storage
  }).array("imgUploader", 3);

app.post("/upload", function(req, res) {
    try{
        upload(req, res, function(err) {
            if (err) {
                return res.json({ result: false });
            }
            return res.json({ result: true });
        });
    } catch (err){
        console.log(err)
        return res.json({ result: false });
    }
    
});

app.listen(process.env.PORT || 3000, () => console.log('Listening na port 3000'))


