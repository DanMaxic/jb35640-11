---
description: exercise 1
---

# תרגיל 1 \(כיתה\)

## תיאור תרגיל

לתלמיד שלום,  
ברוכים הבאים לחברת א.א. שיתופים ותמונות בע״ם. חברת א.א. שיתופים היא חברת סטרטאפ בתקופת הSEED הראשונית שלה ומעסיקה צוות של ארבעה מתכנתים.החברה מעוניינת לבצע השקה של מערכת שנקראת TIME TRACKER.המערכת כיום מורצת על גבי שרתים וירטואלים בסביבת אמזון. הגישה לשרתים מבוצעת על ידשי גישה ישירה לשרתים ללא LOAD BALANCER וללא WAF.  
החברה רוצה לעבור לתצורה של מיקרו-סרוויסים. כמו כן, יתחוור למנהל התשתיות כי לא קיימות מערכות ניטור או חקר ביצועים.  
המפתחים הינם מפתחי ג׳אוה. עליכם להתחלק לשלישיות. כל שלישיה תייצג תפקיד בצוות הDEVOPS.

**מצוות התשתיות נדרשים הדברים הבאים:**

1.הקמת שרתים באופן אוטומטי באמצעות TERRAFORM.2.  
2. נוסף לשרתי האפליקציה נדרשות הטמעת מערכות ניטור על בסיס לוגים ומטריקות.  
עליכם לתכנן את הסביבה וליישם אותה באמצעות טראפורם.

**מצוות הCI\CD:**  
1. להקים גיט רפו תקין לפרוייקט  
2. להקים שרת JENKINS עם slave יחיד  
3. לתכנן את מנגנון ה CI כולל השלבים צוות תשתיות
