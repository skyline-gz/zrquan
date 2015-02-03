FactoryGirl.define do
  factory :user_1, class: User do
		mobile   		  "18620977370"
    name	        "欧阳俊"
    password	    "12345678"
    verified_flag   false
  end

  factory :user_2, class: User do
    mobile   		  "15481345815"
    name  	      "冯庆强"
    password	    "12345678"
    verified_flag   false
  end

  factory :user_3, class: User do
    mobile   		  "15481345812"
    name	        "樊宇祺"
    password	    "12345678"
    verified_flag   true
  end

  factory :user_4, class: User do
    mobile   		  "15481345109"
    name  	      "林志玲"
    password	    "12345678"
    verified_flag   true
  end

  factory :user_5, class: User do
    mobile   		  "15481345115"
    name  	      "高圆圆"
    password	    "12345678"
    verified_flag   true
  end
end
