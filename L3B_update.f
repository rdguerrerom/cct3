       subroutine L3B_update(N0,N1,N2,N3,V3B,
     & K1,K2,K3,K4,
     & FockR,FockB,IntR,IntB,IntM,
     & H1A,H1B,H2A,H2B,H2C,
     & t1A,t1B,t2A,t2B,t2C,
     & l1A,l1B,l2A,l2B,l2C)
C
       integer a,b,c,e,f,g,h,i,j,k,m,n,o,p
       real*8 FockR(N3,N3)
       real*8 FockB(N3,N3)
       real*8 IntR(N0+1:N3,N0+1:N3,N0+1:N3,N0+1:N3)
       real*8 IntB(N0+1:N3,N0+1:N3,N0+1:N3,N0+1:N3)
       real*8 IntM(N0+1:N3,N0+1:N3,N0+1:N3,N0+1:N3)
       real*8 H1A(N0+1:N3,N0+1:N3)
       real*8 H1B(N0+1:N3,N0+1:N3)
       real*8 H2A(N0+1:N3,N0+1:N3,N0+1:N3,N0+1:N3)
       real*8 H2B(N0+1:N3,N0+1:N3,N0+1:N3,N0+1:N3)
       real*8 H2C(N0+1:N3,N0+1:N3,N0+1:N3,N0+1:N3)
       real*8 t1A(N1+1:N3,N0+1:N1)
       real*8 t1B(N2+1:N3,N0+1:N2)
       real*8 t2A(N1+1:N3,N1+1:N3,N0+1:N1,N0+1:N1)
       real*8 t2B(N2+1:N3,N1+1:N3,N0+1:N2,N0+1:N1)
       real*8 t2C(N2+1:N3,N2+1:N3,N0+1:N2,N0+1:N2)
       real*8 l1A(N1+1:N3,N0+1:N1)
       real*8 l1B(N2+1:N3,N0+1:N2)
       real*8 l2A(N1+1:N3,N1+1:N3,N0+1:N1,N0+1:N1)
       real*8 l2B(N2+1:N3,N1+1:N3,N0+1:N2,N0+1:N1)
       real*8 l2C(N2+1:N3,N2+1:N3,N0+1:N2,N0+1:N2)
C
       real*8 V3B(N2+1:N3,N1+1:N3,N1+1:N3,N0+1:N2,N0+1:N1,N0+1:N1)
C
       real*8,allocatable::B1(:,:)
       real*8,allocatable::B2(:,:)
       real*8,allocatable::C1(:,:,:)
       real*8,allocatable::C2(:,:,:)
       real*8,allocatable::D1(:,:,:,:)
       real*8,allocatable::D2(:,:,:,:)
       real*8,allocatable::F1(:,:,:,:,:,:)
       real*8,allocatable::F2(:,:,:,:,:,:)
C
       real*8,allocatable::U1(:,:,:,:,:,:)
       real*8,allocatable::U2(:,:,:,:,:,:)
       real*8,allocatable::U3(:,:,:,:,:,:)
       real*8,allocatable::U4(:,:,:,:,:,:)
       real*8,allocatable::U5(:,:,:,:,:,:)
       real*8,allocatable::U6(:,:,:,:,:,:)
C
       do i=N0+1,N1;do j=N0+1,N1;do k=N0+1,N2
       do a=N1+1,N3;do b=N1+1,N3;do c=N2+1,N3
        V3B(c,b,a,k,j,i)=+H1B(c,k)*l2A(b,a,j,i)
     &                   -H1A(b,i)*l2B(c,a,k,j)
     &                   +H1A(a,i)*l2B(c,b,k,j)
     &                   +H1A(b,j)*l2B(c,a,k,i)
     &                   -H1A(a,j)*l2B(c,b,k,i)
     &                   +l1B(c,k)*H2A(b,a,j,i)
     &                   -l1A(b,i)*H2B(c,a,k,j)
     &                   +l1A(a,i)*H2B(c,b,k,j)
     &                   +l1A(b,j)*H2B(c,a,k,i)
     &                   -l1A(a,j)*H2B(c,b,k,i)
       enddo;enddo;enddo;enddo;enddo;enddo
C
       allocate(D1(N0+1:N1,N2+1:N3,N0+1:N2,N0+1:N1))
       call reorder2134(N0,N3,N0,N3,N0,N3,N0,N3,
     & N0,N1,N2,N3,N0,N2,N0,N1,H2B,D1)
       allocate(D2(N0+1:N1,N1+1:N3,N1+1:N3,N0+1:N1))
       call reorder3124(N1,N3,N1,N3,N0,N1,N0,N1,
     & N0,N1,N1,N3,N1,N3,N0,N1,l2A,D2)
       allocate(U1(N1+1:N3,N1+1:N3,N0+1:N1,N2+1:N3,N0+1:N2,N0+1:N1))
       I1=K1*K2*K4
       I2=K1*K3*K3
       I3=K1
       call EGEMM(I1,I2,I3,D1,D2,U1)
       deallocate(D1)
       deallocate(D2)
C
       call
     & sum235146(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U1,1.000)
       call
     & sum236145(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U1,-1.000)
       deallocate(U1)
C
       allocate(D1(N1+1:N3,N2+1:N3,N1+1:N3,N0+1:N2))
       call reorder4123(N0,N3,N0,N3,N0,N3,N0,N3,
     & N1,N3,N2,N3,N1,N3,N0,N2,H2B,D1)
       allocate(D2(N1+1:N3,N1+1:N3,N0+1:N1,N0+1:N1))
       call reorder1234(N1,N3,N1,N3,N0,N1,N0,N1,
     & N1,N3,N1,N3,N0,N1,N0,N1,l2A,D2)
       allocate(U2(N1+1:N3,N0+1:N1,N0+1:N1,N2+1:N3,N1+1:N3,N0+1:N2))
       I1=K2*K3*K4
       I2=K1*K1*K3
       I3=K3
       call EGEMM(I1,I2,I3,D1,D2,U2)
       deallocate(D1)
       deallocate(D2)
C
       call
     & sum356124(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U2,1.000)
       call
     & sum256134(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U2,-1.000)
       deallocate(U2)
C
       allocate(D1(N0+1:N1,N1+1:N3,N0+1:N1,N0+1:N1))
       call reorder1234(N0,N3,N0,N3,N0,N3,N0,N3,
     & N0,N1,N1,N3,N0,N1,N0,N1,H2A,D1)
       allocate(D2(N0+1:N1,N2+1:N3,N1+1:N3,N0+1:N2))
       call reorder4123(N2,N3,N1,N3,N0,N2,N0,N1,
     & N0,N1,N2,N3,N1,N3,N0,N2,l2B,D2)
       allocate(U3(N2+1:N3,N1+1:N3,N0+1:N2,N1+1:N3,N0+1:N1,N0+1:N1))
       I1=K1*K1*K3
       I2=K2*K3*K4
       I3=K1
       call EGEMM(I1,I2,I3,D1,D2,U3)
       deallocate(D1)
       deallocate(D2)
C
       call
     & sum134256(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U3,1.000)
       call
     & sum124356(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U3,-1.000)
       deallocate(U3)
C
       allocate(D1(N1+1:N3,N1+1:N3,N1+1:N3,N0+1:N1))
       call reorder3124(N0,N3,N0,N3,N0,N3,N0,N3,
     & N1,N3,N1,N3,N1,N3,N0,N1,H2A,D1)
       allocate(D2(N1+1:N3,N2+1:N3,N0+1:N2,N0+1:N1))
       call reorder2134(N2,N3,N1,N3,N0,N2,N0,N1,
     & N1,N3,N2,N3,N0,N2,N0,N1,l2B,D2)
       allocate(U4(N2+1:N3,N0+1:N2,N0+1:N1,N1+1:N3,N1+1:N3,N0+1:N1))
       I1=K1*K3*K3
       I2=K1*K2*K4
       I3=K3
       call EGEMM(I1,I2,I3,D1,D2,U4)
       deallocate(D1)
       deallocate(D2)
C
       call
     & sum145236(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U4,1.000)
       call
     & sum146235(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U4,-1.000)
       deallocate(U4)
C
       allocate(D1(N0+1:N2,N1+1:N3,N0+1:N2,N0+1:N1))
       call reorder1234(N0,N3,N0,N3,N0,N3,N0,N3,
     & N0,N2,N1,N3,N0,N2,N0,N1,H2B,D1)
       allocate(D2(N0+1:N2,N2+1:N3,N1+1:N3,N0+1:N1))
       call reorder3124(N2,N3,N1,N3,N0,N2,N0,N1,
     & N0,N2,N2,N3,N1,N3,N0,N1,l2B,D2)
       allocate(U5(N2+1:N3,N1+1:N3,N0+1:N1,N1+1:N3,N0+1:N2,N0+1:N1))
       I1=K1*K2*K3
       I2=K1*K3*K4
       I3=K2
       call EGEMM(I1,I2,I3,D1,D2,U5)
       deallocate(D1)
       deallocate(D2)
C
       call
     & sum135246(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U5,1.000)
       call
     & sum125346(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U5,-1.000)
       call
     & sum136245(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U5,-1.000)
       call
     & sum126345(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U5,1.000)
       deallocate(U5)
C
       allocate(D1(N2+1:N3,N2+1:N3,N1+1:N3,N0+1:N1))
       call reorder3124(N0,N3,N0,N3,N0,N3,N0,N3,
     & N2,N3,N2,N3,N1,N3,N0,N1,H2B,D1)
       allocate(D2(N2+1:N3,N1+1:N3,N0+1:N2,N0+1:N1))
       call reorder1234(N2,N3,N1,N3,N0,N2,N0,N1,
     & N2,N3,N1,N3,N0,N2,N0,N1,l2B,D2)
       allocate(U6(N1+1:N3,N0+1:N2,N0+1:N1,N2+1:N3,N1+1:N3,N0+1:N1))
       I1=K1*K3*K4
       I2=K1*K2*K3
       I3=K4
       call EGEMM(I1,I2,I3,D1,D2,U6)
       deallocate(D1)
       deallocate(D2)
C
       call
     & sum345126(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U6,-1.000)
       call
     & sum245136(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U6,1.000)
       call
     & sum346125(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U6,1.000)
       call
     & sum246135(N2,N3,N1,N3,N1,N3,N0,N2,N0,N1,N0,N1,V3B,U6,-1.000)
       deallocate(U6)
C
       end
