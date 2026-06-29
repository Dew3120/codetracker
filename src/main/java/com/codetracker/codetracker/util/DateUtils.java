package com.codetracker.codetracker.util;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.TextStyle;
import java.util.Locale;

public class DateUtils {

    public static LocalDate getTodayForUser(String timezone) {
        try {
            return LocalDate.now(ZoneId.of(timezone));
        } catch (Exception ex) {
            return LocalDate.now(ZoneId.of("UTC"));
        }
    }

    public static LocalDate getStartOfWeek(LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.with(DayOfWeek.MONDAY);
    }

    public static LocalDate getEndOfWeek(LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.with(DayOfWeek.SUNDAY);
    }

    public static String getDayName(LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.ENGLISH);
    }

    public static boolean isSameDay(LocalDate d1, LocalDate d2) {
        if (d1 == null || d2 == null) {
            return false;
        }
        return d1.isEqual(d2);
    }
}
