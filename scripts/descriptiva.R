library(ggplot2)
library(dplyr)
library(kableExtra)

# gráfico de la tipología de las bombas por horas
df_summary <- df %>%
  mutate(hour_interval = ceiling_date(hora, "2 hours")) %>%
  group_by(hour_interval, bomba) %>%
  summarize(count = n())

p <- ggplot(data = df_summary, aes(x = hour_interval, y = count, fill = bomba)) + 
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Número de bombas", x = "Hora", y = "") +
  scale_x_datetime(date_labels = "%H:%M", date_breaks = "2 hours") +
  theme_minimal()

# tabla de la tipología de bombas total
ag <- aggregate(bomba ~ as.factor(bomba), data = df, FUN = length)
ag$perc <- paste0(round(ag$bomba/sum(ag$bomba), 4)*100, "%")
names(ag) <- c("Tipo", "Cuenta", "Porcentaje")
ag[order(ag$Cuenta, decreasing = TRUE), ] %>% 
  kable(caption = "Bombas totales", booktabs = TRUE, format = "latex") %>%
  kable_styling(latex_options = "striped")

