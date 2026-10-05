package model;

import java.sql.Date;

public class Voucher {
    private int id;
    private String code;
    private double discountPercent;
    private double discountMax;
    private double minOrderValue;
    private int status = 1;
    private Date expiredAt;

    public Voucher() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public double getDiscountMax() { return discountMax; }
    public void setDiscountMax(double discountMax) { this.discountMax = discountMax; }

    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Date getExpiredAt() { return expiredAt; }
    public void setExpiredAt(Date expiredAt) { this.expiredAt = expiredAt; }

    public double calculateDiscount(double orderTotal) {
        if (orderTotal < minOrderValue) return 0;
        double discount = 0;
        if (discountPercent > 0) {
            discount = orderTotal * (discountPercent / 100.0);
            if (discountMax > 0 && discount > discountMax) {
                discount = discountMax;
            }
        } else if (discountMax > 0) {
            discount = discountMax;
        }
        return Math.min(discount, orderTotal);
    }
}
