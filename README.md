
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>بيت أهلنا - واجهات التطبيق</title>

<style>
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: Arial, sans-serif;
  background: #f5eadb;
  color: #704d32;
}

header {
  background: #704d32;
  color: white;
  text-align: center;
  padding: 35px 15px;
}

header h1 {
  margin: 0;
  font-size: 28px;
}

header p {
  color: #f2d5a8;
  margin-bottom: 0;
}

.container {
  max-width: 1000px;
  margin: auto;
  padding: 20px;
}

.section-title {
  text-align: center;
  margin: 40px 0 25px;
  color: #704d32;
  font-size: 23px;
  padding-bottom: 12px;
  border-bottom: 2px solid #dfc5a5;
}

/* صورتان في كل صف */
.gallery {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 22px;
  align-items: start;
}

.card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 5px 18px #00000015;
  text-align: center;
  border: 1px solid #ead9c5;
  transition: 0.3s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 22px #00000020;
}

.card img {
  width: 100%;
  height: auto;
  display: block;
  object-fit: contain;
  background: #fff;
}

.card h3 {
  margin: 0;
  padding: 15px 8px;
  font-size: 17px;
  color: #704d32;
  border-top: 1px solid #f0e5d9;
}

footer {
  background: #704d32;
  color: white;
  text-align: center;
  padding: 22px;
  margin-top: 45px;
  line-height: 1.8;
}

/* الهاتف */
@media (max-width: 480px) {
  .container {
    padding: 12px;
  }

  .gallery {
    gap: 12px;
  }

  .card {
    border-radius: 12px;
  }

  .card h3 {
    font-size: 14px;
    padding: 12px 5px;
  }

  .section-title {
    font-size: 19px;
  }

  header h1 {
    font-size: 23px;
  }
}
</style>
</head>

<body>

<header>
  <h1>🍽️ بيت أهلنا للمطاعم</h1>
  <p>واجهات تطبيق بيت أهلنا</p>
</header>

<div class="container">

<h2 class="section-title">
🔐 تسجيل الدخول وإنشاء الحساب
</h2>

<div class="gallery">

<div class="card">
<img src="file_00000000b66481f4a87e349163d67daf.png" alt="تسجيل الدخول">
<h3>تسجيل الدخول</h3>
</div>

<div class="card">
<img src="file_00000000572481f4ac9c2acd98dfa888.png" alt="إنشاء حساب">
<h3>إنشاء حساب جديد</h3>
</div>

</div>

<h2 class="section-title">
🏠 واجهات التطبيق الرئيسية
</h2>

<div class="gallery">

<div class="card">
<img src="file_00000000b4a081f4b21f7b87f7a6e915.png" alt="الصفحة الرئيسية">
<h3>الصفحة الرئيسية</h3>
</div>

<div class="card">
<img src="file_0000000051688243a9ac4de5f1de28c5.png" alt="المطاعم">
<h3>صفحة المطاعم</h3>
</div>

<div class="card">
<img src="file_0000000011a0820a80901e669493f509.png" alt="تفاصيل الطعام">
<h3>تفاصيل الطعام</h3>
</div>

<div class="card">
<img src="file_00000000c85881f48020ebc8b10e05e2.png" alt="سلة المشتريات">
<h3>سلة المشتريات</h3>
</div>

<div class="card">
<img src="file_000000005d78824689ec2c6cb3939602.png" alt="الطلبات">
<h3>صفحة الطلبات</h3>
</div>

<div class="card">
<img src="file_0000000073fc82469f8e34d9867db678.png" alt="الصفحة الشخصية">
<h3>الصفحة الشخصية</h3>
</div>

</div>
</div>

<footer>
جميع الحقوق محفوظة © بيت أهلنا للمطاعم
</footer>

</body>
</html>
