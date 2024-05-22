package com.javatechie.crud.example.controller;

import com.javatechie.crud.example.entity.Product;
import com.javatechie.crud.example.entity.User;
import com.javatechie.crud.example.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class ProductController {

    public ProductService getService() {
        return service;
    }

    public void setService(ProductService service) {
        this.service = service;
    }

    @Autowired
    private ProductService service;

    @PostMapping("/addProduct")
    @CrossOrigin
    public Product addProduct(@RequestBody Product product) {
        return service.saveProduct(product);
    }
    @PostMapping("/adduser")
    @CrossOrigin
    public User adduser(@RequestBody User user) {
        return service.adduser(user);
    }

    @PostMapping("/addProducts")
    @CrossOrigin
    public List<Product> addProducts(@RequestBody List<Product> products) {
        return service.saveProducts(products);
    }

    @GetMapping("/products")
    @CrossOrigin
    public List<Product> findAllProducts() {
        return service.getProducts();
    }
    @GetMapping("/users")
    @CrossOrigin
    public List<User> findAllUsers() {
        return service.getUsers();
    }

    @GetMapping("/productById/{id}")
    @CrossOrigin
    public Product findProductById(@PathVariable int id) {
        return service.getProductById(id);
    }

    @PutMapping("/update")
    @CrossOrigin
    public Product updateProduct(@RequestBody Product product) {
        return service.updateProduct(product);
    }

    @DeleteMapping("/delete/{id}")
    @CrossOrigin
    public String deleteProduct(@PathVariable int id) {
        return service.deleteProduct(id);
    }
}
