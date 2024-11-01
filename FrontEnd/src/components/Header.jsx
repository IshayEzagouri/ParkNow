import React, { useState, useEffect } from 'react';
import { Navbar, NavbarBrand, NavbarMenuToggle, NavbarMenuItem, NavbarMenu, NavbarContent, NavbarItem, Button } from '@nextui-org/react';
import { useAuth } from '../Context/AuthContext';
import { Link, useLocation } from 'react-router-dom';
import ThemeSwitcher from './ThemeSwitcher';
import { useTheme } from '../Context/ThemeContext';
import NotificationBadge from './NotificationBadge';
import { fetchUserDetails, fetchUnreadNotificationsCount } from '../api/userApi';
import { io } from 'socket.io-client';

const Header = () => {
  const { isDarkMode, setIsDarkMode } = useTheme();
  const { isAuthenticated, loading, logoutUser } = useAuth();
  const location = useLocation();

  const [socket, setSocket] = useState(null);
  const [notificationsCount, setNotificationsCount] = useState(0);
  const [userData, setUserData] = useState(null);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const menuItems = [
    { name: 'Home', path: '/' },
    { name: 'Cities', path: '/cities' },
    { name: 'Subscriptions', path: '/subscriptions' }
  ];

  const isActivePath = (path) => location.pathname === path;

  // Set up backend URL based on environment
  const backendURL =
    process.env.NODE_ENV === 'production'
      ? 'https://parknow-backend.up.railway.app' // Production URL
      : 'http://localhost:3001'; // Local URL

  useEffect(() => {
    const handleUserData = async () => {
      try {
        const userInfo = await fetchUserDetails();
        setUserData(userInfo);

        const unreadCount = await fetchUnreadNotificationsCount();
        setNotificationsCount(unreadCount);

        // Initialize socket connection with the correct backend URL and user ID
        if (userInfo?.idUsers && !socket) {
          const socketConnection = io(backendURL, {
            auth: { userId: userInfo.idUsers }
          });

          setSocket(socketConnection);

          socketConnection.on('new-notification', (notification) => {
            if (notification.userId === null || notification.userId === userInfo.idUsers) {
              setNotificationsCount((prevCount) => prevCount + 1);
            }
          });

          socketConnection.on('unread-notifications-count', (newCount) => {
            setNotificationsCount(newCount);
          });

          return () => {
            socketConnection.disconnect();
          };
        }
      } catch (error) {
        console.error('Error fetching user details or unread notifications:', error);
      }
    };

    if (!userData) {
      handleUserData();
    }
  }, [userData, socket]);

  return (
    <Navbar isMenuOpen={isMenuOpen} onMenuOpenChange={setIsMenuOpen} isBordered isBlurred={true} className={isDarkMode ? 'bg-dark-bg' : ''}>
      <NavbarContent>
        <NavbarMenuToggle aria-label={isMenuOpen ? 'Close menu' : 'Open menu'} className='sm:hidden' />
        <NavbarBrand>
          <div className='flex items-center gap-4'>
            <svg viewBox='0 0 48 48' fill='none' xmlns='http://www.w3.org/2000/svg' className='w-4 h-4 text'>
              <path d='M44 4H30.6666V17.3334H17.3334V30.6666H4V44H44V4Z' fill='currentColor'></path>
            </svg>
            <p className='text text-lg font-bold leading-tight tracking-[-0.015em]'>ParkNow</p>
          </div>
        </NavbarBrand>
      </NavbarContent>

      <NavbarContent className='hidden sm:flex gap-4' justify='center'>
        {menuItems.map((item, index) => (
          <NavbarItem key={index} isActive={isActivePath(item.path)}>
            <Link to={item.path} color='foreground'>
              {item.name}
            </Link>
          </NavbarItem>
        ))}
      </NavbarContent>

      <NavbarContent
        className={`transition-opacity duration-500 ease-in-out ${loading ? 'opacity-0 invisible' : 'opacity-100 visible'}`}
        justify='end'
      >
        {isAuthenticated && <NotificationBadge setNotificationsCount={setNotificationsCount} notificationsCount={notificationsCount} />}
        <NavbarItem>
          <ThemeSwitcher setIsDarkMode={setIsDarkMode} isDarkMode={isDarkMode} />
        </NavbarItem>
        {!loading && !isAuthenticated && (
          <>
            <NavbarItem>
              <Button as={Link} color='primary' to='/login' variant='shadow'>
                Log In
              </Button>
            </NavbarItem>
            <NavbarItem>
              <Button as={Link} color='default' to='/signup' variant='shadow'>
                Sign Up
              </Button>
            </NavbarItem>
          </>
        )}
        {!loading && isAuthenticated && (
          <NavbarItem>
            <Button color='danger' onClick={logoutUser} variant='solid'>
              Log Out
            </Button>
          </NavbarItem>
        )}
      </NavbarContent>

      <NavbarMenu className={`navbar-menu ${isDarkMode ? 'dark' : ''}`}>
        {menuItems.map((item, index) => (
          <NavbarMenuItem key={`${item.name}-${index}`}>
            <Link
              onClick={() => setIsMenuOpen(false)}
              color={index === 2 ? 'primary' : 'foreground'}
              className='w-full dark:text-white'
              to={item.path}
              size='lg'
            >
              {item.name}
            </Link>
          </NavbarMenuItem>
        ))}
      </NavbarMenu>
    </Navbar>
  );
};

export default Header;
