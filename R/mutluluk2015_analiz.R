# ------------------------------------------------------------
# Name:        mutluluk2015_analiz.R
# Author:      Hüseyin Taştan
# Date:        09/07/2023
# Description: 2015 yılı il bazında mutluluk göstergelerinin
#              analizi için script dosyası
# ------------------------------------------------------------
Sys.setlocale("LC_ALL","turkish")
rm(list = objects()) # clear workspace

# kullanılan paketler
library(tidyverse)
library(readxl)
veriler <- read_excel("data/mutluluk2015.xls", range = "A6:BA88")

# ismi "..." ile başlayan boş sütunları sil
veriler <- veriler %>%
  dplyr::select(-contains('...'))
# note: select() may not work right if MASS is package is also loaded
veriler <- veriler |> drop_na()

# TR isimlendirme
# mevcut veri setindeki değişken isimlerini içeren karakter vektörü
isim_tanim <- names(veriler)
isim_tanim[42]

# bu karakter vektörünün elemanlarını değiştir:
isimler <- isim_tanim
isimler[1] <- "il"
isimler[2] <- "oda"
isimler[3] <- "tuv"
isimler[4] <- "ev_kalite"
isimler[5] <- "istihdam"
isimler[6] <- "issizlik"
isimler[7] <- "ort_gun_kazanc"
isimler[8] <- "is_tatmin"
isimler[9] <- "tasarruf"
isimler[10] <- "orta_ust_gelir_gr"
isimler[11] <- "temel_iht_gr"
isimler[12] <- "bebek_mort"
isimler[13] <- "yasam_bek"
isimler[14] <- "doktor_basv"
isimler[15] <- "saglik_tatmin"
isimler[16] <- "kamu_saglik_tatmin"
isimler[17] <- "okullasma_3_5"
isimler[18] <- "TEOG"
isimler[19] <- "YGS"
isimler[20] <- "yuk_egit_orani"
isimler[21] <- "kamu_egit_tatmin"
isimler[22] <- "hava_kir"
isimler[23] <- "orman_alan"
isimler[24] <- "atik_hiz"
isimler[25] <- "gurultu_kir"
isimler[26] <- "bel_temiz_tatmin"
isimler[27] <- "cinayet"
isimler[28] <- "tra_kaza"
isimler[29] <- "gece_guv_yuru"
isimler[30] <- "kamu_guv_tatmin"
isimler[31] <- "oy_verme_belediye"
isimler[32] <- "uyelik_siy_parti"
isimler[33] <- "sendika"
isimler[34] <- "internet"
isimler[35] <- "kanalizasyon"
isimler[36] <- "havaalani"
isimler[37] <- "kamu_ulasim_tatmin"
isimler[38] <- "sin_tiyatro"
isimler[39] <- "avm"
isimler[40] <- "sosyal_ilis_tatmin"
isimler[41] <- "sosyal_hayat_tatmin"
isimler[42] <- "mutluluk"

# sütun isimlerini değiştir:
colnames(veriler) <- isimler
# verilere göz at
glimpse(veriler)

# save(veriler, file = "R/yasamveri2015.RData")

# özet istatistikler
summary(veriler$mutluluk)

# histogram
veriler %>% ggplot(mapping = aes(x = mutluluk)) +
  geom_histogram(bins = 6, color = "darkblue", fill = "lightblue")

# dplyr::summarise ile özet istatistikler
veriler |> summarise(ortalama = mean(mutluluk),
                     medyan = median(mutluluk),
                     sd = sd(mutluluk),
                     min = min(mutluluk),
                     max = max(mutluluk)
)

library(skimr)
skim(veriler)

# en mutlu 10 il
veriler |>
  dplyr::select(il, mutluluk) |>
  arrange(desc(mutluluk)) |>
  head(10)

# en mutsuz 10 il
veriler |>
  dplyr::select(il, mutluluk) |>
  arrange(mutluluk) |>
  head(10)

# mutluluk sıralaması, tüm iller
ggplot(veriler, aes(x = mutluluk, y = fct_reorder(il, mutluluk))) +
  geom_point() +
  theme(axis.text.y = element_text(size = 5)) +
  labs(title = "Mutluluk sıralaması (2015)",
       subtitle = "Kaynak: TÜİK") +
  xlab("Mutluluk düzeyi") +
  ylab("")

# korelasyon matrisi
library(corrplot)
corrplot(cor(veriler[-1]), is.corr=TRUE, order = "FPC", tl.cex=0.6)

# serpilme çizimleri
# İşsizlik oranı vs. Mutluluk
ggplot(veriler, aes(x = issizlik, y = mutluluk)) +
  geom_point()

# İşsizlik oranı vs. Mutluluk
# il etiketleri ekle
veriler |>
  ggplot(aes(x = issizlik, y = mutluluk, label = il)) +
  geom_point(color = "blue", size = 2) +
  geom_text(hjust = 0, vjust = -0.5, color="gray") +
  theme_minimal()

# Mutluluk için basit bir doğrusal regresyon modeli
reg_mutluluk <- lm(mutluluk ~ issizlik + ort_gun_kazanc + yuk_egit_orani +
                     hava_kir + cinayet + sin_tiyatro, data = veriler)
summary(reg_mutluluk)



