package com.javatechie.crud.example.repository;

import com.javatechie.crud.example.entity.Frame;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FrameRepository extends JpaRepository<Frame,Integer> {
}

