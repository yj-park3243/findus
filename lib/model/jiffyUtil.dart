//게시판 카테고리 조회
String changeMnTime(String time)  {
  print(time);
  if(time.contains('A few seconds ago')){
    return 'Саяхан';
  } else if(time.contains('minutes ago')){
    return time.replaceAll('minutes ago', 'минутын өмнө');
  } else if(time.contains('hours ago')){
    return time.replaceAll('hours ago', 'цагийн өмнө');
  } else if(time.contains('days ago')){
    return time.replaceAll('days ago', 'хоногийн өмнө');
  } else if(time.contains('years ago')){
    return time.replaceAll('years ago', 'жилийн өмнө');
  } else if(time.contains('a minute ago')){
    return time.replaceAll('a minute ago', '1 минутын өмнө');
  } else if(time.contains('a hour ago')){
    return time.replaceAll('a hour ago', '1 цагийн өмнө');
  } else if(time.contains('a day ago')){
    return time.replaceAll('a day ago', '1 хоногийн өмнө');
  }
  return time;
}