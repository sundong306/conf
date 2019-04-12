#!/bin/bash


####查汇率
USD_CNY_Rate=`curl -s  "https://sapi.k780.com/?app=finance.rate&scur=USD&tcur=CNY&appkey=41067&sign=c271abc34d3da764686d60301e0a359a"   |  awk -F  "rate"  '{print $3}'  | awk  -F '"'  '{print $3}'`
HKD_CNY_Rate=`curl -s "https://sapi.k780.com/?app=finance.rate&scur=HKD&tcur=CNY&appkey=41067&sign=c271abc34d3da764686d60301e0a359a"    |  awk -F  "rate"  '{print $3}'  | awk  -F '"'  '{print $3}'`

#####查价
ipad-pro3 () { 
Product_US_Price=`curl -k  -s  "https://www.apple.com/shop/buy-ipad/ipad-pro/11-inch-display-64gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_HK_Price=`curl -k  -s  "https://www.apple.com/hk/shop/buy-ipad/ipad-pro/11-inch-display-64gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_CN_Price=`curl -k  -s  "https://p.3.cn/prices/mgets?skuIds=J_100000205012&type=1"  | awk  -F '"'  '{print $(NF-1)}'`
}

ipad-air3 () { 
Product_US_Price=`curl -k  -s  "https://www.apple.com/shop/buy-ipad/ipad-air/64gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_HK_Price=`curl -k  -s  "https://www.apple.com/hk/shop/buy-ipad/ipad-air/64gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_CN_Price=`curl -k  -s  "https://p.3.cn/prices/mgets?skuIds=J_100002716267&type=1"  | awk  -F '"'  '{print $(NF-1)}'`
}


ipad-2018 () { 
Product_US_Price=`curl -k  -s  "https://www.apple.com/shop/buy-ipad/ipad-9-7/32gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_HK_Price=`curl -k  -s  "https://www.apple.com/hk/shop/buy-ipad/ipad-9-7/32gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_CN_Price=`curl -k  -s  "https://p.3.cn/prices/mgets?skuIds=J_6962865&type=1"  | awk  -F '"'  '{print $(NF-1)}'`
}


ipad-mini5 () { 
Product_US_Price=`curl -k  -s  "https://www.apple.com/shop/buy-ipad/ipad-mini/64gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_HK_Price=`curl -k  -s  "https://www.apple.com/hk/shop/buy-ipad/ipad-mini/64gb-space-gray-wifi"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_CN_Price=`curl -k  -s  "https://p.3.cn/prices/mgets?skuIds=J_100002716277&type=1"  | awk  -F '"'  '{print $(NF-1)}'`
}

macbook-pro-2017 ()  {
Product_US_Price=`curl -k  -s  "https://www.apple.com/shop/buy-mac/macbook-pro/13-inch-space-gray-2.3ghz-dual-core-256gb#"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_HK_Price=`curl -k  -s  "https://www.apple.com/hk/shop/buy-mac/macbook-pro/13-inch-space-gray-2.3ghz-dual-core-256gb#"  | grep  --colour  "priceCurrency" | head -1  | awk  -F   "price"  '{print $3}'  | awk  -F '[":,]'  '{print $3}'`
Product_CN_Price=`curl -k  -s  "https://p.3.cn/prices/mgets?skuIds=J_5225342&type=1"  | awk  -F '"'  '{print $(NF-1)}'`
}



#####比价
Products-Prices-Converter ()  {
Product_US_Price_exchange=`echo "$Product_US_Price * $USD_CNY_Rate" | bc`
Product_HK_Price_exchange=`echo "$Product_HK_Price * $HKD_CNY_Rate" | bc`
echo -e  "\033[32m The US Version in CNY is:  $Product_US_Price_exchange  \033[0m "
echo -e  "\033[32m The HK Version in CNY is:  $Product_HK_Price_exchange  \033[0m "
echo -e  "\033[32m The CN Version in CNY is:  $Product_CN_Price			  \033[0m "
}



###### Last:更新操作提示语
Fun_List(){
echo 
cat << EOF
请选查询项:
##请选择需要查询哪个机器的报价
echo "[1] ipad-pro3/MTXN2CH/A 11-inch-display-64gb-space-gray-wifi"
echo "[2] ipad-air3/MUUK2CH/A 64gb-space-gray-wifi"
echo "[3] ipad2018/MR7G2CH/A 32gb-space-gray-wifi"
echo "[4] ipad-mini5/MUQX2CH/A 64gb-space-gray-wifi"
echo "[5] macbook-pro/13-inch-space-gray-2.3ghz-dual-core-256gb#"
q: 退出。
EOF

echo ""
echo "注意：【请选择需要查询哪个机器的报价】"
echo ""
read -p "请选查询项 :>" Product_ID
case "$Product_ID" in
    1)
         echo "[`date`] ipad-pro3/MTXN2CH/A 11-inch-display-64gb-space-gray-wifi  \n"  
         ipad-pro3 ；
		 Products-Prices-Converter  ；
         Fun_List;
         ;;
    2)
        echo  "[`date`] ipad-air3/MUUK2CH/A 64gb-space-gray-wifi  \n"  
        ipad-air3 ；
		Products-Prices-Converter  ；
        Fun_List;
        ;;	
    3)
         echo  "[`date`] ipad2018/MR7G2CH/A 32gb-space-gray-wifi  \n"  
         ipad-2018 ；
		 Products-Prices-Converter  ；
         Fun_List;
         ;;
    4)
         echo  "[`date`] ipad-mini5/MUQX2CH/A 64gb-space-gray-wifi  \n"  
         ipad-mini5 ；
		 Products-Prices-Converter  ；
         Fun_List;
         ;;	
    5)
         echo  "[`date`] macbook-pro/13-inch-space-gray-2.3ghz-dual-core-256gb#  \n"  
         macbook-pro-2017 ；
		 Products-Prices-Converter  ；
         Fun_List;
         ;;	 	 
    Q|q|quit|exit)
         echo "Thank you!"
         ;;
    ""|*)
        Fun_List
        ;;
    esac
} 

Fun_List

