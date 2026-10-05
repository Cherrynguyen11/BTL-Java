package model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OmniStats {
    private double totalRevenue;
    private int totalOrders;
    private int totalProducts;
    private int totalCustomers;
    private Map<String, Double> revenueByChannel = new HashMap<>();
    private Map<String, Integer> ordersByChannel = new HashMap<>();
    private List<Product> topSellingProducts;
    private List<ProductVariant> lowStockVariants;

    public OmniStats() {}

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }

    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }

    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }

    public int getTotalCustomers() { return totalCustomers; }
    public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }

    public Map<String, Double> getRevenueByChannel() { return revenueByChannel; }
    public void setRevenueByChannel(Map<String, Double> revenueByChannel) { this.revenueByChannel = revenueByChannel; }

    public Map<String, Integer> getOrdersByChannel() { return ordersByChannel; }
    public void setOrdersByChannel(Map<String, Integer> ordersByChannel) { this.ordersByChannel = ordersByChannel; }

    public List<Product> getTopSellingProducts() { return topSellingProducts; }
    public void setTopSellingProducts(List<Product> topSellingProducts) { this.topSellingProducts = topSellingProducts; }

    public List<ProductVariant> getLowStockVariants() { return lowStockVariants; }
    public void setLowStockVariants(List<ProductVariant> lowStockVariants) { this.lowStockVariants = lowStockVariants; }

    public double getRevenue(String channel) {
        return revenueByChannel.getOrDefault(channel, 0.0);
    }

    public int getOrderCount(String channel) {
        return ordersByChannel.getOrDefault(channel, 0);
    }
}
